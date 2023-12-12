# frozen_string_literal: true

module Seijaku
  # Group of SSH hosts
  class SSHGroup
    attr_reader :hosts

    def initialize(ssh_group)
      @hosts = {}
      ssh_group.each do |host|
        @hosts[host["host"]] = Host.new(host)
      end
    end
  end
end
