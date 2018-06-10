require 'net/ssh'
# require "open_directory_utils/dscl"
# require "open_directory_utils/pwpolicy"
require "open_directory_utils/commands_base"
require "open_directory_utils/commands_group"
require "open_directory_utils/commands_user_attribs_od"
require "open_directory_utils/commands_user_attribs_ldap"

module OpenDirectoryUtils
  class Connection

    attr_reader :srv_info, :dir_info

    # include OpenDirectoryUtils::Dscl
    # include OpenDirectoryUtils::Pwpolicy
    include OpenDirectoryUtils::CommandsBase
    include OpenDirectoryUtils::CommandsGroup
    include OpenDirectoryUtils::CommandsUserAttribsOd
    include OpenDirectoryUtils::CommandsUserAttribsLdap

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
                    dsedit: config[:dsedit_path],
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
      # pp ssh_cmds
      results  = send_cmds_to_od_server(ssh_cmds)
      # pp results
      process_results(results, command, params, ssh_cmds)
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

    def process_results(results, command, params, ssh_cmds)

      if command.eql?(:user_exists?) or command.eql?(:group_exists?)
        return user_or_group_exist(results, command, params, ssh_cmds)
      end

      results_str = results.to_s
      errors = true         if results_str.include? 'Error'
      errors = false    unless results_str.include? 'Error'
      if results_str.include?('Group not found') or               # can't find group to move user into
          results.to_s.include?('eDSRecordNotFound') or           # return error if resource wasn't found
          results_str.include?('Record was not found') or         # can't find user to move into a group
          results.to_s.include?('eDSAuthAccountDisabled') or      # can't set passwd when disabled
          results_str.include?('unknown AuthenticationAuthority') # can't reset password when account disabled
        return format_results(results, command, params, ssh_cmds, true)
      end

      if command.eql?(:user_password_verified?) or command.eql?(:user_password_ok?)
        return password_check(results, command, params, ssh_cmds)
      end

      if command.eql?(:user_login_enabled?)
        return login_check(results, command, params, ssh_cmds)
      end

      if command.eql?(:user_in_group?) or command.eql?(:group_has_user?)
        username = params[:value]
        unless username.nil? or username.eql? '' or username.include? ' ' or
                results_str.include?('eDSRecordNotFound')
          results = [true, results]      if results_str.include?( username )
          results = [false, results] unless results_str.include?( username )
        end
      end

      if errors and ( results_str.include?('eDSRecordNotFound') or
                      results_str.include?('unknown AuthenticationAuthority') )
        results = ["Resource not found", results]
      end

      return format_results(results, command, params, ssh_cmds, errors)

    end

    def format_results(results, command, params, ssh_cmds, errors)
      answer = case errors
      when false
        {success:{response: results, command: command, attributes: params}}
      else
        {error:  {response: results, command: command,
                  attributes: params, dscl_cmds: ssh_cmds}}
      end
      return answer
    end

    def login_check(results, command, params, ssh_cmds)
      # puts "login enabled -- #{results}".upcase
      enabled = login_enabled?(results.to_s)
      results = [ enabled, results ]
      return format_results(results, command, params, ssh_cmds, false)
    end
    def login_enabled?(results_str)
      return false if results_str.include?('account is disabled')
      return false if results_str.include?('isDisabled=1')
      # some enabled accounts return no policies ?#$?
      # return true  if results_str.include?('isDisabled=0')
      true
    end

    def password_check(results, command, params, ssh_cmds)
      passed  = password_verified?(results.to_s)
      results = [ passed, results ]
      return format_results(results, command, params, ssh_cmds, false)
    end
    def password_verified?(results_str)
      return false if results_str.include?('eDSAuthFailed')
      true
    end

    def user_or_group_exist(results, command, params, ssh_cmds)
      found   = record_found?(results.to_s)
      results = [ found, results ]
      return format_results(results, command, params, ssh_cmds, false)
    end
    def record_found?(results_str)
      return false  if results_str.include?('eDSRecordNotFound')
      true
    end

    def defaults
      {
        srv_hostname: ENV['OD_HOSTNAME'],
        srv_username: ENV['OD_USERNAME'],
        ssh_options:  (eval(ENV['OD_SSH_OPTIONS'].to_s) || {}),

        dir_username: ENV['DIR_ADMIN_USER'],
        dir_password: ENV['DIR_ADMIN_PASS'],
        dir_datapath: (ENV['DIR_DATAPATH'] || '/LDAPv3/127.0.0.1'),

        dscl_path:    ENV['DSCL_PATH']   || '/usr/bin/dscl',
        pwpol_path:   ENV['PWPOL_PATH']  || '/usr/bin/pwpolicy',
        dsedit_path:  ENV['DSEDIT_PATH'] || '/usr/sbin/dseditgroup',
      }
    end

  end
end
