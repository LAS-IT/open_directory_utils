require "open_directory_utils/clean_check"

module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module Dscl

    include OpenDirectoryUtils::CleanCheck

    # builds the dscl command (with complete flexibility)
    # attribs [Hash] - required - :record_name (the resource to affect), :action (create, append, delete, passwd, etc), attribute: (resource attribute to change), value: (value to add to attribute)
    # dir_info [Hash] - usually configured in the connection initializer and then passed to dscl to build command correctly
    def dscl(attribs, dir_info)
      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :action )
      check_critical_attribute( attribs, :scope )
      tidy_attribs = tidy_attribs(attribs)
      build_dscl_command( tidy_attribs, dir_info )
    end

    # TODO: switch to template pattern
    def build_dscl_command(attribs, dir_info)
      # allow :recordname to be passed-in if using dscl directly
      attribs[:record_name] = attribs[:record_name] || attribs[:recordname]
      # /usr/bin/dscl -u diradmin -P "BigSecret" /LDAPv3/127.0.0.1 -append /Users/$UID_USERNAME apple-keyword "$VALUE"
      # "/usr/bin/dscl -plist -u #{od_username} -P #{od_password} #{od_dsclpath} -#{command} #{resource} #{params}"
      ans  = "#{dir_info[:dscl]}"
      unless attribs[:format].nil?
        ans += ' -plist'                           if attribs[:format].eql? 'plist' or
                                                      attribs[:format].eql? 'xml'
      end
      ans += " -u #{dir_info[:username]}"      unless dir_info[:username].nil? or
                                                      dir_info[:username].empty? or
                                                      attribs[:action].eql? 'auth'
      ans += %Q[ -P "#{dir_info[:password]}"]    unless dir_info[:password].nil? or
                                                      dir_info[:password].empty? or
                                                      attribs[:action].eql? 'auth'
      ans += " #{dir_info[:data_path]}"

      ans += %Q[ -#{attribs[:action]}]
      ans += %Q[ #{attribs[:record_name]}]         if attribs[:action].eql? 'auth'
      ans += %Q[ /#{attribs[:scope]}/#{attribs[:record_name]}] unless
                                                      attribs[:action].eql? 'auth'
      ans += %Q[ #{attribs[:attribute]}]       unless attribs[:attribute].nil? or
                                                      attribs[:attribute].empty?
      ans += %Q[ "#{attribs[:value]}"]         unless attribs[:value].nil? or
                                                      attribs[:value].empty?
      return ans
    end

  end
end
