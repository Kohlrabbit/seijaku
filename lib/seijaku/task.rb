# frozen_string_literal: true

module Seijaku
  # Task is composed of a name, an array of Step (Pre, Post)
  class Task
    attr_reader :host

    def initialize(task, variables, logger, ssh_hosts = nil, ssh_settings = {})
      @name = task.fetch(:name, nil)
      @host = task.fetch(:host, nil)
      @steps = task.fetch(:steps, []).map { |step| Step.new(step, variables, :steps, logger, self, ssh_hosts, ssh_settings) }
      @pre_steps = task.fetch(:pre, []).map { |step| Step.new(step, variables, :pre, logger, self, ssh_hosts, ssh_settings) }
      @post_steps = task.fetch(:post, []).map { |step| Step.new(step, variables, :post, logger, self, ssh_hosts, ssh_settings) }
      @logger = logger

      raise TaskError, "no name set in task", [] if @name.nil?
    end

    def execute!
      [@pre_steps, @steps, @post_steps].each do |pipeline_steps|
        pipeline_steps.each do |step|
          @logger.info(format("[%<name>s:%<pipeline>s] running %<command>s",
                              name: @name,
                              pipeline: step.pipeline,
                              command: step.command))

          step.execute!
        end
      end
    end
  end
end
