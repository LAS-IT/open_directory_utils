module OpenDirectoryUtils
  class Connection

    attr_reader :hostname, :username, :servicename, :eqcmd_path, :ssh_options

    include OpenDirectoryUtils::UserCommands

    def initialize(params={})
      config = defaults.merge(params)
      @hostname    = config[:hostname]
      @username    = config[:username]
      @servicename = config[:servicename]
      @eqcmd_path  = config[:eqcmd_path]
      @ssh_options = config[:ssh_options]

      raise ArgumentError, 'hostname missing'    if hostname.nil? or hostname.empty?
      raise ArgumentError, 'username missing'    if username.nil? or username.empty?
      raise ArgumentError, 'servicename missing' if servicename.nil? or servicename.empty?
    end

    def run(command:, attributes:)
      cmd = send(command, attributes)
      send_eqcmd(cmd)
    end

    private

    def send_eqcmd(cmd)
      Net::SSH.start(hostname, username, ssh_options) do |ssh|
        output = ssh.exec!(ssh_cmd)
      end
    end

    def defaults
      { hostname: ENV['OD_HOSTNAME'],
        username: ENV['OD_USERNAME'],
        servicename: ENV['OD_SERVICENAME'],
        ssh_options: (eval(ENV['OD_SSH_OPTIONS'].to_s) || {}) }
    end

  end
end
