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

    def run(command:, params:, formatting: nil)
      answer = {}
      ssh_cmd = send(command, params, dir_info)
      results = send_cmds_to_od_server(ssh_cmd)
      format_results(results, command, params)
      rescue ArgumentError, NoMethodError => error
        answer[:error]   =  "#{error.message} -- command: :#{command} with attribs: #{params}"
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

    def format_results(results, command, params)
      errors = true         if results.to_s.include? 'Error'
      errors = false    unless results.to_s.include? 'Error'

      if command.eql? :user_exists?
        errors  = false        # in this case not actually an error
        unless results.to_s.include?('eDSRecordNotFound')
          results = true
        else
          results = false
        end
      end

      ans = case errors
      when false
        {success:{response: results, command: command, attributes: params}}
      else
        {error:  {response: results, command: command, attributes: params}}
      end
      return ans
    end

    def defaults
      {
        srv_hostname: ENV['OD_HOSTNAME'],
        srv_username: ENV['OD_USERNAME'],
        ssh_options:  (eval(ENV['OD_SSH_OPTIONS'].to_s) || {}),

        dir_username: ENV['DIR_USERNAME'],
        dir_password: ENV['DIR_PASSWORD'],
        dir_datapath: (ENV['DIR_DATAPATH'] || '/LDAPv3/127.0.0.1/'),

        dscl_path:    ENV['DSCL_PATH']  || '/usr/bin/dscl',
        pwpol_path:   ENV['PWPOL_PATH'] || '/usr/bin/pwpolicy'
      }
    end

  end
end
