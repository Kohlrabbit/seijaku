# frozen_string_literal: true

require "net/ssh"
require "net/ssh/proxy/jump"

module Seijaku
  # SSHExecutor connects to SSH host and runs command
  class SSHExecutor
    def initialize(raw, variables, task, ssh_hosts)
      @command = ["sh", "-c", "'#{raw}'"]
      @hosts = ssh_hosts
      @variables = variables
      @task = task
      @ssh_hosts = ssh_hosts

      raise SSHExecutorError, "no ssh host defined in payload", [] if ssh_hosts.nil?
    end

    def run!
      machine = @ssh_hosts.hosts[@task.host]
      result = { command: @command.join(" "), stdout: nil, stderr: nil }
      status = {}
      options = machine.bastion ? { proxy: bastion_setup } : {}
      ssh = Net::SSH.start(machine.host, machine.user, port: machine.port, **options)
      ssh.exec!(@command.join(" "), status: status) do |_ch, stream, data|
        result[:stdout] = data.chomp if stream == :stdout
        result[:stderr] = data.chomp unless stream == :stdout
      end
      ssh.close

      result[:exit_status] = status[:exit_code]
      result
    end

    def bastion_setup
      bastion_name = @ssh_hosts.hosts[@task.host].bastion
      bastion_host = @ssh_hosts.hosts[bastion_name]

      connect_str = "#{bastion_host.user}@#{bastion_host.host}:#{bastion_host.port}"
      Net::SSH::Proxy::Jump.new(connect_str)
    end
  end
end
