# frozen_string_literal: true

require "open3"

module Seijaku
  # Execute `sh` commands
  class SHExecutor
    def initialize(raw, variables)
      @command = ["sh", "-c", "'#{raw}'"]
      @variables = variables
    end

    def run!
      stdout, stderr, exit_status = Open3.capture3(
        @variables,
        @command.join(" ")
      )

      {
        stdout: stdout.chomp,
        stderr: stderr.chomp,
        exit_status: exit_status.exitstatus,
        command: @command.join(" ")
      }
    end
  end
end
