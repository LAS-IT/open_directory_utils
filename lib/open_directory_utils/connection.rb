require 'net/ssh'
require "open_directory_utils/user_actions"

module OpenDirectoryUtils
  class Connection

    attr_reader :srv_hostname, :srv_username, :ssh_options
    attr_reader :dir_datapath, :dir_username, :dir_password
    attr_reader :dscl_cmdpath

    include OpenDirectoryUtils::UserActions

    def initialize(params={})
      config = defaults.merge(params)

      @srv_hostname = config[:srv_hostname]
      @srv_username = config[:srv_username]
      @ssh_options  = config[:ssh_options]

      @dir_username = config[:dir_username]
      @dir_password = config[:dir_password]
      @dir_datapath = config[:dir_datapath]

      @dscl_cmdpath = config[:dscl_cmdpath]

      raise ArgumentError, 'server hostname missing' if srv_hostname.nil? or
                                                        srv_hostname.empty?
      raise ArgumentError, 'server username missing' if srv_username.nil? or
                                                        srv_username.empty?
    end

    # def run(command:, attributes:, formatting: nil)
    #   result = ''
    #   begin
    #     action   = send(:check_uid, command, attributes)
    #     ssh_cmd  = build_full_command(action)
    #     response = send_eqcmd(ssh_cmd)
    #     result   = post_processing(command, response)
    #   rescue ArgumentError, NoMethodError => error
    #     result   = "#{error.message} -- command: :#{command} with attribs: #{attributes}"
    #   end
    #   return result
    # end

    private

    def prep_actions(actions_in, formatting=nil)
      actions = Array( actions_in )
      od_cmds = []
      actions.each do |act|
        od_cmds << build_full_command(act, formatting)
      end
      od_cmds
    end

    def build_full_command(cmd_actions, formatting=nil)
      # /usr/bin/dscl -u diradmin -P "BigSecret" /LDAPv3/127.0.0.1/ -append /Users/$UID_USERNAME apple-keyword "$VALUE"
      # "/usr/bin/dscl -plist -u #{od_username} -P #{od_password} #{od_dsclpath} -#{command} #{resource} #{params}"
      ans  = "#{dscl_cmdpath}"
      ans += ' -plist'                 unless formatting.nil? or formatting.empty?
      ans += " -u #{dir_username}"     unless dir_username.nil? or dir_username.empty?
      ans += %Q{ -P "#{dir_password}"} unless dir_password.nil? or dir_password.empty?
      ans += " #{dir_datapath}"
      ans += " #{cmd_actions}"
      return ans
    end

    def send_all_cmds(cmds)
      cmd_array = Array( cmds )
      output = []
      Net::SSH.start(srv_hostname, srv_username, ssh_options) do |ssh|
        cmd_array.each do |one_cmd|
          output << (ssh.exec!(one_cmd)).strip
        end
      end
      return output
    end

    # def process_answer(command, answer)
    #   return answer
    # end

    def defaults
      {
        srv_hostname: ENV['OD_HOSTNAME'],
        srv_username: ENV['OD_USERNAME'],
        ssh_options:  (eval(ENV['OD_SSH_OPTIONS'].to_s) || {}),

        dir_username: ENV['DIR_USERNAME'],
        dir_password: ENV['DIR_PASSWORD'],
        dir_datapath: (ENV['DIR_DATAPATH'] || '/LDAPv3/127.0.0.1/'),

        dscl_cmdpath: ENV['DIR_CMDPATH'] || '/usr/bin/dscl',
      }
    end

  end
end
