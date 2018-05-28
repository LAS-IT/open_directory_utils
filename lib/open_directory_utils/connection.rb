require 'net/ssh'
require "open_directory_utils/user_actions"

module OpenDirectoryUtils
  class Connection

    attr_reader :srv_hostname, :srv_username, :ssh_options
    attr_reader :diradmin #:dir_datapath, :dir_username, :dir_password
    attr_reader :command_paths #,:dscl_cmdpath

    # include OpenDirectoryUtils::Assertions
    include OpenDirectoryUtils::UserActions

    def initialize(params={})
      config = defaults.merge(params)

      @srv_hostname = config[:srv_hostname]
      @srv_username = config[:srv_username]
      @ssh_options  = config[:ssh_options]

      dir_username = config[:dir_username]
      dir_password = config[:dir_password]
      dir_datapath = config[:dir_datapath]
      @diradmin_info = {username: dir_username, password: dir_password,
                        data_path: dir_datapath}

      dscl_cmdpath  = config[:dscl_cmdpath]
      pwpol_cmdpath = config[:pwpol_cmdpath]
      @command_paths = {dscl: dscl_cmdpath, pwpolicy: pwpol_cmdpath}

      raise ArgumentError, 'server hostname missing' if srv_hostname.nil? or
                                                        srv_hostname.empty?
      raise ArgumentError, 'server username missing' if srv_username.nil? or
                                                        srv_username.empty?
    end

    def run(command:, attributes:, formatting: nil)
      answer = {}
      begin
        ssh_cmd = send(command, attributes, diradmin_info)
        # action  = send(:check_action, command, attributes)
        # ssh_cmd = build_full_command(action)
        results = send_od_cmds(ssh_cmd)
        answer  = format_results(results, command, attributes)
      rescue ArgumentError, NoMethodError => error
        answer[:error]   =  "#{error.message} -- command: :#{command} with attribs: #{attributes}"
      end
      return answer
    end

    private

    def prep_actions(actions_in, formatting=nil)
      actions = Array( actions_in )
      od_cmds = []
      actions.each do |act|
        od_cmds << build_full_command(act, formatting)
      end
      od_cmds
    end

    # def build_full_command(cmd_actions, formatting=nil)
    #   # /usr/bin/dscl -u diradmin -P "BigSecret" /LDAPv3/127.0.0.1/ -append /Users/$UID_USERNAME apple-keyword "$VALUE"
    #   # "/usr/bin/dscl -plist -u #{od_username} -P #{od_password} #{od_dsclpath} -#{command} #{resource} #{params}"
    #   ans  = "#{dscl_cmdpath}"
    #   ans += ' -plist'                 unless formatting.nil? or formatting.empty?
    #   ans += " -u #{dir_username}"     unless dir_username.nil? or dir_username.empty?
    #   ans += %Q{ -P "#{dir_password}"} unless dir_password.nil? or dir_password.empty?
    #   ans += " #{dir_datapath}"
    #   ans += " #{cmd_actions}"
    #   return ans
    # end

    def send_od_cmds(cmds)
      cmd_array = Array( cmds )
      output = []
      Net::SSH.start(srv_hostname, srv_username, ssh_options) do |ssh|
        cmd_array.each do |one_cmd|
          output << (ssh.exec!(one_cmd)).strip
        end
      end
      return output
    end

    def format_results(results, command, attributes)
      # any Errors?
      # https://makandracards.com/makandra/31141-ruby-counting-occurrences-of-an-item-in-an-array-enumerable
      error_count = results.count { |r| r.include? 'Error' }

      if command.eql? :users_exists?
        # user found
        return { success:
                  {response: true, command: command, attributes: attributes}
                }  if error_count.eql? 0
        # user not found
        return { success:
                  {response: false, command: command, attributes: attributes}
                }  if results.first.include? 'eDSRecordNotFound'
      end

      # return success response - when no errors found
      return { success:
                {response: results, command: command, attributes: attributes}
              }  if error_count.eql? 0
      # return error response - when errors found
      return { error:
                {response: results, command: command, attributes: attributes}
              }  if error_count >= 0
    end

    def defaults
      {
        srv_hostname: ENV['OD_HOSTNAME'],
        srv_username: ENV['OD_USERNAME'],
        ssh_options:  (eval(ENV['OD_SSH_OPTIONS'].to_s) || {}),

        dir_username: ENV['DIR_USERNAME'],
        dir_password: ENV['DIR_PASSWORD'],
        dir_datapath: (ENV['DIR_DATAPATH'] || '/LDAPv3/127.0.0.1/'),

        dscl_cmdpath:  ENV['DSCL_PATH']  || '/usr/bin/dscl',
        pwpol_cmdpath: ENV['PWPOL_PATH'] || '/usr/bin/pwpolicy'
      }
    end

  end
end
