require "open_directory_utils/clean_check"

module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsBase

    include OpenDirectoryUtils::CleanCheck

    # builds the pwpolicy commands (after checking parameters)
    # @attribs [Hash] - required - :record_name (the resource/user/group to affect), attribute: (resource attribute to change), value: (value to add to attribute)
    # @dir_info [Hash] - usually configured in the connection initializer and then passed to pwpolicy to build command correctly
    def pwpolicy(params, dir_info)
      check_critical_attribute( params, :record_name )
      cmd_params = tidy_attribs(params)

      build_pwpolicy_command( cmd_params, dir_info )
    end

    # builds the dscl command (after checking parameters)
    # @attribs [Hash] - required - :record_name (the resource to affect), :action (create, append, delete, passwd, etc), attribute: (resource attribute to change), value: (value to add to attribute)
    # @dir_info [Hash] - usually configured in the connection initializer and then passed to dscl to build command correctly
    def dscl(attribs, dir_info)
      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :action )
      check_critical_attribute( attribs, :scope )
      tidy_attribs = tidy_attribs(attribs)
      build_dscl_command( tidy_attribs, dir_info )
    end

    def dseditgroup(attribs, dir_info)
      check_critical_attribute( attribs, :value )
      check_critical_attribute( attribs, :operation )
      if attribs[:operation].eql?('edit')
        check_critical_attribute( attribs, :record_name )
        check_critical_attribute( attribs, :action )
        check_critical_attribute( attribs, :type )
      end
      tidy_attribs = tidy_attribs(attribs)
      build_dseditgroup_command( tidy_attribs, dir_info )
    end

    # /usr/bin/pwpolicy -a diradmin -p "BigSecret" -u username -setpolicy "isDisabled=0"
    def build_pwpolicy_command(params, dir_info)
      ans  = %Q[#{dir_info[:pwpol]}]
      ans += %Q[ -a #{dir_info[:username]}]    unless dir_info[:username].nil? or
                                                      dir_info[:username].empty?
      ans += %Q[ -p "#{dir_info[:password]}"]  unless dir_info[:password].nil? or
                                                      dir_info[:password].empty?
      # ans += %Q[ -n #{dir_info[:data_path]}]
      ans += %Q[ -u #{params[:record_name]}]
      ans += %Q[ -#{params[:attribute]}]
      ans += %Q[ "#{params[:value]}"]          unless params[:value].nil? or
                                                      params[:value].empty?
      return ans
    end

    # TODO: switch to template pattern
    def build_dscl_command(attribs, dir_info)
      # allow :recordname to be passed-in if using dscl directly
      attribs[:record_name] = attribs[:record_name] || attribs[:recordname]
      # /usr/bin/dscl -u diradmin -P "BigSecret" /LDAPv3/127.0.0.1/ -append /Users/$UID_USERNAME apple-keyword "$VALUE"
      # "/usr/bin/dscl -plist -u #{od_username} -P #{od_password} #{od_dsclpath} -#{command} #{resource} #{params}"
      ans  = %Q[#{dir_info[:dscl]}]
      unless attribs[:format].nil?
        ans += ' -plist'                           if attribs[:format].eql? 'plist' or
                                                      attribs[:format].eql? 'xml'
      end
      ans += %Q[ -u #{dir_info[:username]}]    unless dir_info[:username].nil? or
                                                      dir_info[:username].empty? or
                                                      attribs[:action].eql? 'auth'
      ans += %Q[ -P "#{dir_info[:password]}"]  unless dir_info[:password].nil? or
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

    # http://www.manpagez.com/man/8/dseditgroup/
    # make a new group:
    # dseditgroup -o create -n /LDAPv3/ldap.company.com -u dir_admin_user -P dir_admin_passwd \
    #           -r "Real Group Name" -c "a comment" -k "keyword" groupname
    # delete a new group:
    # dseditgroup -o delete -n /LDAPv3/ldap.company.com -u dir_admin_user -P dir_admin_passwd groupname
    # add a user to a group
    # dseditgroup -o edit -n /LDAPv3/ldap.company.com -u dir_admin_user -P dir_admin_passwd -a username -t user groupname
    # remove a user from a group
    # dseditgroup -o edit -n /LDAPv3/ldap.company.com -u dir_admin_user -P dir_admin_passwd -d username -t user groupname
    def build_dseditgroup_command( params, dir_info )
      ans  = %Q[#{dir_info[:dsedit]}]
      ans += %Q[ -o #{params[:operation]}]
      ans += %Q[ -u #{dir_info[:username]}]    unless dir_info[:username].nil? or
                                                      dir_info[:username].empty?
      ans += %Q[ -P "#{dir_info[:password]}"]  unless dir_info[:password].nil? or
                                                      dir_info[:password].empty?
      ans += %Q[ -n #{dir_info[:data_path]}]
      if params[:operation].eql?('create')
        ans += %Q[ -r "#{params[:value]}"]         if params[:real_name].to_s.eql?('')
        ans += %Q[ -r "#{params[:real_name]}"] unless params[:real_name].to_s.eql?('')
        ans += %Q[ -k #{params[:keyword]}]     unless params[:keyword].to_s.eql?('')
      end
      if params[:operation].eql?('edit')
        ans += %Q[ -a #{params[:record_name]}]     if params[:action].to_s.eql?('add')
        ans += %Q[ -d #{params[:record_name]}]     if params[:action].to_s.eql?('delete')
        ans += %Q[ -t #{params[:type]}]            # type can be user or group
      end
      ans += %Q[ #{params[:value]}]   # the group to be manipulated
    end

  end
end
