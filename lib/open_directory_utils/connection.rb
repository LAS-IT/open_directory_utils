require 'net/ssh'
require "open_directory_utils/user_actions"

module OpenDirectoryUtils
  class Connection

    attr_reader :srv_hostname, :srv_username, :ssh_options
    attr_reader :diradmin_info, :command_paths

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
        results = send_od_cmds(ssh_cmd)
        answer  = format_results(results, command, attributes)
      rescue ArgumentError, NoMethodError => error
        answer[:error]   =  "#{error.message} -- command: :#{command} with attribs: #{attributes}"
      end
      return answer
    end

    private

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
