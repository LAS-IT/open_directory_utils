require "open_directory_utils/clean_check"

module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module Pwpolicy

    include OpenDirectoryUtils::CleanCheck

    def build_pwpolicy_command(params, dir_info)
      # /usr/bin/pwpolicy -a diradmin -p "BigSecret" -u username -setpolicy "isDisabled=0"
      ans  = "#{dir_info[:pwpol]}"
      ans += " -a #{dir_info[:diradmin]}"      unless dir_info[:diradmin].nil? or
                                                      dir_info[:diradmin].empty?
      ans += %Q[ -p "#{dir_info[:password]}"]  unless dir_info[:password].nil? or
                                                      dir_info[:password].empty?
      ans += %Q[ -u #{params[:shortname]}]
      ans += %Q[ -#{params[:attribute]}]
      ans += %Q[ "#{params[:value]}"]          unless params[:value].nil? or
                                                      params[:value].empty?
      return ans
    end

    def pwpolicy(params, dir_info)
      check_critical_attribute( params, :shortname )
      cmd_params = tidy_attribs(params)

      build_pwpolicy_command( cmd_params, dir_info )
    end

    ## PRE-BUILT commands
    #####################
    # /usr/bin/pwpolicy -a diradmin -p A-B1g-S3cret -u $shortname_USERNAME -setpolicy "isDisabled=0"
    def user_enable_login(params, dir_info)
      check_critical_attribute( params, :shortname )
      user_attrs = tidy_attribs(params)

      answer  = add_pwpolicy_info( dir_info )
      answer += %Q[ -u #{user_attrs[:shortname]} -enableuser]
      # answer += %Q[ -u #{user_attrs[:shortname]} -setpolicy "isDisabled=0"]

      return answer
    end
    # /usr/bin/pwpolicy -a diradmin -p A-B1g-S3cret -u $shortname_USERNAME -setpolicy "isDisabled=1"
    def user_disable_login(params, dir_info)
      check_critical_attribute( params, :shortname )
      user_attrs = tidy_attribs(params)

      answer  = add_pwpolicy_info( dir_info )
      answer += %Q[ -u #{user_attrs[:shortname]} -disableuser]
      # answer += %Q[ -u #{user_attrs[:shortname]} -setpolicy "isDisabled=1"]

      return answer
    end

    def add_pwpolicy_info(dir_info)
      # /usr/bin/pwpolicy -a diradmin -p "BigSecret" -u username -setpolicy "isDisabled=0"
      ans  = "#{dir_info[:pwpol]}"
      # ans += ' -plist'                        unless format_info.nil?  or
      #                                                 format_info.empty?
      ans += " -a #{dir_info[:diradmin]}"      unless dir_info[:diradmin].nil? or
                                                      dir_info[:diradmin].empty?
      ans += %Q[ -p "#{dir_info[:password]}"]  unless dir_info[:password].nil? or
                                                      dir_info[:password].empty?
      return ans
    end


  end
end
