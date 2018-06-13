require 'net/ssh'
require "open_directory_utils/commands_base"
require "open_directory_utils/commands_user_attribs"
# require "open_directory_utils/commands_user_attribs_ldap"
require "open_directory_utils/commands_user_create_remove"
require "open_directory_utils/commands_group_create_remove"

module OpenDirectoryUtils
  class Connection

    attr_reader :srv_info, :dir_info

    include OpenDirectoryUtils::CommandsBase
    include OpenDirectoryUtils::CommandsUserAttribs
    # include OpenDirectoryUtils::CommandsUserAttribsLdap
    include OpenDirectoryUtils::CommandsUserCreateRemove
    include OpenDirectoryUtils::CommandsGroupCreateRemove

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
      results   = send_cmds_to_od_server(ssh_cmds)
      # pp results
      answer = process_results(results, command, params, ssh_cmds )
      return answer
      rescue ArgumentError, NoMethodError => error
        format_results(error.message, command, params, ssh_cmds, success: false)
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
        return report_existence(results, command, params, ssh_cmds)
      end
      if missing_resource?(results)
        results = ["Resource not found", results]
        # report lack of success
        return format_results(results, command, params, ssh_cmds, success: false)
      end
      if command.eql?(:user_password_verified?) or command.eql?(:user_password_ok?)
        return report_password_check(results, command, params, ssh_cmds)
      end
      if command.eql?(:user_login_enabled?)
        return report_login_check(results, command, params, ssh_cmds)
      end
      if command.eql?(:user_in_group?)
        return report_in_group(results, command, params, ssh_cmds)
      end
      if missed_errors?(results)
        results = ["Unexpected Error", results]
        format_results(results, command, params, ssh_cmds, success: false)
      end
      # return any general success answers
      format_results(results, command, params, ssh_cmds, success: true)
    end

    def format_results(results, command, params, ssh_cmds, success:)
      ssh_clean = ssh_cmds.to_s
      ssh_clean = ssh_clean.gsub(/-[p] ".+"/, '-p "************"')
      ssh_clean = ssh_clean.gsub(/-[P] ".+"/, '-P "************"')

      case success
      when true
        return { success:{response: results, command: command,
                          attributes: params, dscl_cmds: ssh_clean} }
      else
        return { error:  {response: results, command: command,
                          attributes: params, dscl_cmds: ssh_clean} }
      end
    end

    def report_existence(results, command, params, ssh_cmds)
      results = [false, results]    if results.to_s.include?('eDSRecordNotFound')
      results = [true, results] unless results.to_s.include?('eDSRecordNotFound')
      return format_results(results, command, params, ssh_cmds, success: true)
    end

    def missing_resource?(results)
      results_str = results.to_s
      return true  if results_str.include?('Group not found') or              # can't find group to move user into
                      results_str.include?('eDSRecordNotFound') or            # return error if resource wasn't found
                      results_str.include?('Record was not found') or         # can't find user to move into a group
                      results_str.include?('eDSAuthAccountDisabled') or       # can't set passwd when disabled
                      results_str.include?('unknown AuthenticationAuthority') # can't reset password when account disabled
      return false
    end

    def report_password_check(results, command, params, ssh_cmds)
      results = [false, results]    if results.to_s.include?('eDSAuthFailed')
      results = [true, results] unless results.to_s.include?('eDSAuthFailed')
      return format_results(results, command, params, ssh_cmds, success: true)
    end

    def missed_errors?(results)
      results_str = results.to_s
      return true  if results_str.include? 'Error'
      return false
    end

    def report_login_check(results, command, params, ssh_cmds)
      results = [false, results]     if results.to_s.include?('isDisabled=1')
      results = [false, results]     if results.to_s.include?('account is disabled')
      results = [true, results]  unless results.to_s.include?('isDisabled=1') or
                                        results.to_s.include?('account is disabled')
      return format_results(results, command, params, ssh_cmds, success: true)
    end

    def report_in_group(results, command, params, ssh_cmds)
      username = params[:value]
      results = [true, results]      if results.to_s.include?( username )
      results = [false, results] unless results.to_s.include?( username )
      return format_results(results, command, params, ssh_cmds, success: true)
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
