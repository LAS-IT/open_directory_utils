require "open_directory_utils/clean_check"

module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module Dscl

    include OpenDirectoryUtils::CleanCheck

    # get user record -- dscl . -read /Users/<username>
    # get user value  -- dscl . -read /Users/<username> <key>
    # search od user  -- dscl . -search /Users RealName "Andrew Garrett"
    # return as xml   -- dscl -plist . -search /Users RealName "Andrew Garrett"
    def dscl(attribs, dir_info)
      check_critical_attribute( attribs, :shortname )
      check_critical_attribute( attribs, :action )
      check_critical_attribute( attribs, :scope )
      tidy_attribs = tidy_attribs(attribs)
      build_dscl_command( tidy_attribs, dir_info )
    end

    def build_dscl_command(attribs, dir_info)
      # /usr/bin/dscl -u diradmin -P "BigSecret" /LDAPv3/127.0.0.1/ -append /Users/$UID_USERNAME apple-keyword "$VALUE"
      # "/usr/bin/dscl -plist -u #{od_username} -P #{od_password} #{od_dsclpath} -#{command} #{resource} #{params}"
      ans  = "#{dir_info[:dscl]}"
      unless attribs[:format].nil?
        ans += ' -plist'                           if attribs[:format].eql? 'plist' or
                                                      attribs[:format].eql? 'xml'
      end
      ans += " -u #{dir_info[:diradmin]}"      unless dir_info[:diradmin].nil? or
                                                      dir_info[:diradmin].empty?
      ans += %Q[ -P "#{dir_info[:password]}"]  unless dir_info[:password].nil? or
                                                      dir_info[:password].empty?
      ans += " #{dir_info[:data_path]}"

      ans += %Q[ -#{attribs[:action]}]
      ans += %Q[ /#{attribs[:scope]}/#{attribs[:shortname]}]
      ans += %Q[ #{attribs[:attribute]}]       unless attribs[:attribute].nil? or
                                                      attribs[:attribute].empty?
      ans += %Q[ "#{attribs[:value]}"]         unless attribs[:value].nil? or
                                                      attribs[:value].empty?
      return ans
    end

  end
end
