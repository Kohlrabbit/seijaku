# frozen_string_literal: true

module Seijaku
  # Payload refers to the payload YAML file submitted by the user.
  # it includes tasks, steps, variables and name.
  class Payload
    attr_reader :name

    def initialize(payload, logger)
      @name = payload.fetch(:name)
      @variables = get_variables(payload.fetch(:variables))
      @ssh_hosts = SSHGroup.new(payload.fetch(:ssh, []))
      @ssh_settings = payload.fetch(:ssh_settings, {})
      @tasks = payload.fetch(:tasks).map do |task|
        Task.new(task, @variables, logger, @ssh_hosts, @ssh_settings)
      end
    end

    def execute!
      @tasks.each(&:execute!)
    end

    def get_variables(payload_variables)
      sorted_variables = {}
      variables = payload_variables.map do |var|
        Variable.new(var)
      end

      variables.each do |var|
        sorted_variables.merge!({ var.key => var.value })
      end

      sorted_variables
    end
  end
end
