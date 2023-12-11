# frozen_string_literal: true

require_relative "seijaku/version"
require_relative "seijaku/payload"
require_relative "seijaku/variable"
require_relative "seijaku/task"
require_relative "seijaku/step"

require_relative "seijaku/executors/sh"
require_relative "seijaku/executors/bash"

module Seijaku
  class Error < StandardError; end
  class VariableError < Error; end
  class TaskError < Error; end
end