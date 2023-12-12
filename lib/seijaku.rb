# frozen_string_literal: true

require_relative "seijaku/version"
require_relative "seijaku/payload"
require_relative "seijaku/variable"
require_relative "seijaku/task"
require_relative "seijaku/step"
require_relative "seijaku/ssh/group"
require_relative "seijaku/ssh/host"

require_relative "seijaku/executors/sh"
require_relative "seijaku/executors/bash"
require_relative "seijaku/executors/ssh"

module Seijaku
  class Error < StandardError; end
  class VariableError < Error; end
  class TaskError < Error; end
  class SSHExecutorError < Error; end
end
