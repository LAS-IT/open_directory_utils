require 'net/ssh'
require "open_directory_utils/dscl"
require "open_directory_utils/pwpolicy"
require "open_directory_utils/commands_user"
require "open_directory_utils/commands_group"

module OpenDirectoryUtils
  class Connection

    attr_reader :srv_info, :dir_info

    include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::Pwpolicy
    include OpenDirectoryUtils::CommandsUser
    include OpenDirectoryUtils::CommandsGroup

    # configure connection with ENV_VARS (or parameters)
    # @params [Hash] - reqiured info includes: srv_hostname:, srv_username: (password: if not using ssh-keys)
    # @note - mostly likely needed for better security is -- dir_username:, dir_password:
    def initialize(params={})
      config = defaults.merge(params)

      @srv_info = { hostname: config[:srv_hostname],
                    username: config[:srv_username],
                    ssh_options: config[:ssh_options]}
      @dir_info = { username: config[:dir_username],
                    password: config[:dir_password],
                    data_path: config[:dir_datapath],
                    dscl: config[:dscl_path],
                    pwpol: config[:pwpol_path],
                  }
      raise ArgumentError, 'server hostname missing' if srv_info[:hostname].nil? or
                                                        srv_info[:hostname].empty?
      raise ArgumentError, 'server username missing' if srv_info[:username].nil? or
                                                        srv_info[:username].empty?
    end

    # after configuring a connection with .new - send commands via ssh to open directory
    # @command [Symbol] - required -- to choose the action wanted
    # @params [Hash] - required -- necessary information to accomplish action
    # @output [String] - optional -- 'xml' or 'plist' will return responses using xml format
    def run(command:, params:, output: nil)
      answer = {}
      params[:format] = output
      # just in case clear record_name and calculate later
      params[:record_name] = nil
      ssh_cmds = send(command, params, dir_info)
      results  = send_cmds_to_od_server(ssh_cmds)
      # pp ssh_cmds
      # pp results
      format_results(results, command, params, ssh_cmds)
      rescue ArgumentError, NoMethodError => error
        {error:  {response: error.message, command: command,
                  attributes: params, dscl_cmds: ssh_cmds}}
    end

    private

    def send_cmds_to_od_server(cmds)
      cmd_array = Array( cmds )
      output = []
      Net::SSH.start( srv_info[:hostname], srv_info[:username],
                      srv_info[:ssh_options] ) do |ssh|
          cmd_array.each do |one_cmd|
            output << (ssh.exec!(one_cmd)).strip
          end
      end
      return output
    end

    def format_results(results, command, params, ssh_cmds)
      errors = true         if results.to_s.include? 'Error'
      errors = false    unless results.to_s.include? 'Error'

      if command.eql?(:user_exists?) or command.eql?(:group_exists?)
        errors  = false        # in this case not actually an error
        unless results.to_s.include?('eDSRecordNotFound')
          results = [true]
        else
          results = [false]
        end
      end

      if command.eql?(:user_in_group?) or command.eql?(:group_has_user?)
        username = nil
        username = username || params[:user_name]
        username = username || params[:username]
        username = username || params[:uid]
        username = username.to_s.strip

        raise ArgumentError, "username invalid or missing"  if username.eql? '' or username.include? ' '
        raise ArgumentError, "groupname invalid or missing" if results.to_s.include?('eDSRecordNotFound')

        if results.to_s.include?( username )
          results = [true]
        else
          results = [false]
        end
      end

      ans = case errors
      when false
        {success:{response: results, command: command, attributes: params}}
      else
        {error:  {response: results, command: command,
                  attributes: params, dscl_cmds: ssh_cmds}}
      end
      return ans
    end

    def defaults
      {
        srv_hostname: ENV['OD_HOSTNAME'],
        srv_username: ENV['OD_USERNAME'],
        ssh_options:  (eval(ENV['OD_SSH_OPTIONS'].to_s) || {}),

        dir_username: ENV['DIR_ADMIN_USER'],
        dir_password: ENV['DIR_ADMIN_PASS'],
        dir_datapath: (ENV['DIR_DATAPATH'] || '/LDAPv3/127.0.0.1/'),

        dscl_path:    ENV['DSCL_PATH']  || '/usr/bin/dscl',
        pwpol_path:   ENV['PWPOL_PATH'] || '/usr/bin/pwpolicy'
      }
    end

  end
end
