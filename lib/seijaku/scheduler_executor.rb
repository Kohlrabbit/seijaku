module Seijaku
  class SchedulerExecutor
    attr_reader :name
    attr_accessor :status

    def initialize(payload_obj, scheduler_spec, logger)
      @name = scheduler_spec.fetch("name", nil)
      @every = scheduler_spec.fetch("every", nil)
      @payload_file = scheduler_spec.fetch("payload")

      @logger = logger
      @payload = payload_obj
      @status = :awaiting
    end

    def execute!
      while @status != :exiting do
        @logger.info "[SCHEDULER] <<- starting execution: #{@name}"

        @status = :started
        @payload.execute!
        @status = :awaiting

        @logger.info "[SCHEDULER] <<- finished execution: #{@name} (#{@every}s)"
        sleep @every
      end

      @status = :exited
    end
  end
end
