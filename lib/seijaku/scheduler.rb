# frozen_string_literal: true

module Seijaku
  class Scheduler
    def initialize(scheduler, logger)
      @name = scheduler.fetch("name", nil)
      @logger = logger
      @scheduler_executors = scheduler.fetch("payloads", []).map do |payload_spec|
        payload = File.read(payload_spec["payload"]).then do |data|
          YAML.safe_load(data).then do |data|
            Payload.new(data, logger)
          end
        end

        SchedulerExecutor.new(payload, payload_spec, logger)
      end
    end

    def monitor!
      thd = []
      @scheduler_executors.each do |scheduler_executor|
        @logger.info "scheduling... #{scheduler_executor.name}"
        thd << Thread.new do
          scheduler_executor.execute!
        end
      end

      thd.each &:join
    end

    def soft_exit!
      @logger.info "Soft exit asked by user, waiting for payloads to stop naturally..."
      thd = []
      @scheduler_executors.each do |scheduler_executor|
        thd << Thread.new do
          scheduler_executor.status = :exiting
          while scheduler_executor.status != :exited
            @logger.info "#{scheduler_executor.name}: still waiting..."
            sleep 1
          end

          @logger.info "#{scheduler_executor.name}: stopped gracefully"
        end
      end
      thd.each &:join
    end
  end
end
