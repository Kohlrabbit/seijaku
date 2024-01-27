# frozen_string_literal: true

module Seijaku
  # Host of SSHGroup
  class Host
    attr_reader :host, :port, :user, :bastion

    def initialize(host)
      @host = host.fetch(:host, "localhost")
      @port = host.fetch(:port, 22)
      @bastion = host.fetch(:bastion, nil)
      @user = host.fetch(:user, "root")
    end
  end
end
