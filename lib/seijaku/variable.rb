# frozen_string_literal: true

module Seijaku
  # variable
  class Variable
    attr_reader :key, :value

    def initialize(variable)
      @key = variable.first

      value = variable.last
      @value = value

      return unless value.start_with?("$")

      env_key = value.split("$").last
      env_value = ENV.fetch(env_key, nil)

      raise VariableError, "no value set for #{env_key}", [] if env_value.nil?

      @value = env_value
    end
  end
end
