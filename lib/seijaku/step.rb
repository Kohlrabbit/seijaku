# frozen_string_literal: true

module Seijaku
  # A step is a bash or sh command that must be executed.
  # steps execution is always fifo.
  class Step
    attr_reader :command, :pipeline

    def initialize(step, variables, pipeline, logger)
      @sh = step.fetch("sh", nil)
      @bash = step.fetch("bash", nil)
      @soft_fail = step.fetch("soft_fail", false)
      @output = step.fetch("output", false)
      @variables = variables
      @pipeline = pipeline
      @logger = logger

      @command = @sh || @bash
    end

    def execute!
      result = SHExecutor.new(@sh, @variables).run! if @sh
      result = BashExecutor.new(@bash, @variables).run! if @bash

      if result[:exit_status] != 0
        logger_output(result)
        exit(1) unless @soft_fail
      end

      return unless @output

      %i[stdout stderr].each do |stream|
        puts format("%<stream>s:\t %<result>s", stream: stream, result: result[stream])
      end
    end

    def logger_output(result)
      @logger.info <<~OUTPUT
        command: `#{result[:command]}`
        exit_code: #{result[:exit_status]}
        stdout: #{result[:stdout]}
        stderr: #{result[:stderr]}"
      OUTPUT
    end
  end
end
