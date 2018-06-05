require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"

module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsUser

    include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck

    def user_record_name_alternatives(attribs)
      attribs[:record_name] = attribs[:record_name] || attribs[:username]
      attribs[:record_name] = attribs[:record_name] || attribs[:uid]
      return attribs
    end

    # GET INFO
    ##########
    # get user record -- dscl . -read /Users/<username>
    # get user value  -- dscl . -read /Users/<username> <key>
    # search od user  -- dscl . -search /Users RealName "Andrew Garrett"
    # return as xml   -- dscl -plist . -search /Users RealName "Andrew Garrett"
    def user_get_info(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'read', scope: 'Users', attribute: nil, value: nil}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_info, :user_get_info

    # get all usernames -- dscl . -list /Users
    # get all user details -- dscl . -readall /Users
    def user_exists?(attribs, dir_info)
      user_get_info(attribs, dir_info)
    end

    # CHANGE OD
    ###########
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER RealName "$VALUE"
    def user_set_real_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:cn]
      attribs[:value] = attribs[:value] || attribs[:realname]
      attribs[:value] = attribs[:value] || attribs[:real_name]
      attribs[:value] = attribs[:value] || "#{attribs[:first_name]} #{attribs[:last_name]}"

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :real_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'RealName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER cn "$NAME"
    def user_set_common_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:cn]
      attribs[:value] = attribs[:value] || attribs[:realname]
      attribs[:value] = attribs[:value] || attribs[:real_name]
      attribs[:value] = attribs[:value] || "#{attribs[:first_name]} #{attribs[:last_name]}"

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :common_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'cn'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_cn, :user_set_common_name


    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME FirstName "$VALUE"
    def user_set_first_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:given_name]
      attribs[:value] = attribs[:value] || attribs[:first_name]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :first_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'FirstName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME givenName "$VALUE"
    def user_set_given_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:given_name]
      attribs[:value] = attribs[:value] || attribs[:first_name]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :given_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'givenName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME LastName "$VALUE"
    def user_set_last_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:sn]
      attribs[:value] = attribs[:value] || attribs[:surname]
      attribs[:value] = attribs[:value] || attribs[:last_name]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :last_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'LastName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME sn "$VALUE"
    def user_set_surname(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:sn]
      attribs[:value] = attribs[:value] || attribs[:surname]
      attribs[:value] = attribs[:value] || attribs[:last_name]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :surname )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'sn'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_sn, :user_set_surname

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME NameSuffix "$VALUE"
    def user_set_name_suffix
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-namesuffix "$VALUE"
    def user_set_apple_name_suffix
    end



    # sudo dscl . -create /Users/someuser UniqueID "1010"
    def user_set_unique_id(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:uniqueid]
      attribs[:value] = attribs[:value] || attribs[:unique_id]
      attribs[:value] = attribs[:value] || attribs[:uidnumber]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :unique_id )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'UniqueID'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # # sudo dscl . -create /Users/someuser uidnumber "1010"
    def user_set_uidnumber(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:uniqueid]
      attribs[:value] = attribs[:value] || attribs[:unique_id]
      attribs[:value] = attribs[:value] || attribs[:uidnumber]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :unique_id )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'uidnumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # sudo dscl . -create /Users/someuser PrimaryGroupID 80
    def user_set_primary_group_id(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:group_id]
      attribs[:value] = attribs[:value] || attribs[:gidnumber]
      attribs[:value] = attribs[:value] || attribs[:primary_group_id]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :group_id )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'PrimaryGroupID'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # sudo dscl . -create /Users/someuser PrimaryGroupID 80
    def user_set_gidnumber(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:group_id]
      attribs[:value] = attribs[:value] || attribs[:gidnumber]
      attribs[:value] = attribs[:value] || attribs[:group_number]
      attribs[:value] = attribs[:value] || attribs[:primary_group_id]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :group_id )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'gidnumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/someuser NFSHomeDirectory /Users/someuser
    def user_set_nfs_home_directory(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:home_directory]
      attribs[:value] = attribs[:value] || attribs[:nfs_home_directory]
      attribs[:value] = attribs[:value] || '/Volumes/Macintosh HD/Users/someone'

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :home_directory )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'NFSHomeDirectory'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME homedirectory "$VALUE"
    def user_set_home_directory(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:home_directory]
      attribs[:value] = attribs[:value] || attribs[:nfs_home_directory]
      attribs[:value] = attribs[:value] || '/Volumes/Macintosh HD/Users/someone'

      command = {action: 'create', scope: 'Users', attribute: 'homedirectory'}
      attribs = attribs.merge(command)

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :home_directory )
      user_attrs = tidy_attribs(attribs)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/pwpolicy -a diradmin -p "TopSecret" -u username -setpassword "AnotherSecret"
    # /usr/bin/dscl -plist -u diradmin -P #{adminpw} /LDAPv3/127.0.0.1/ -passwd /Users/#{shortname} "#{passwd}"
    def user_set_password(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:password]
      attribs[:value] = attribs[:value] || attribs[:passwd]
      attribs[:value] = attribs[:value] || '*'

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :password )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'passwd', scope: 'Users'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # /usr/bin/dscl /LDAPv3/127.0.0.1 -auth #{shortname} "#{passwd}"
    def user_verify_password(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:password]
      attribs[:value] = attribs[:value] || attribs[:passwd]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :password )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'auth', scope: 'Users'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # sudo dscl . -create /Users/someuser UserShell /bin/bash
    def user_set_shell(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:user_shell]
      attribs[:value] = attribs[:value] || attribs[:shell]
      attribs[:value] = attribs[:value] || '/bin/bash'

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :shell )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'UserShell'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME loginShell "$VALUE"
    def user_set_login_shell(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:user_shell]
      attribs[:value] = attribs[:value] || attribs[:shell]
      attribs[:value] = attribs[:value] || '/bin/bash'

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :shell )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'loginShell'}
      user_attrs  = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end


    # OTHER FIELDS
    #####################
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME mail "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME email "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-user-mailattribute "$VALUE"
    def user_set_email(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs['apple-user-mailattribute']
      attribs[:value] = attribs[:value] || attribs[:apple_user_mailattribute]
      attribs[:value] = attribs[:value] || attribs[:email]
      attribs[:value] = attribs[:value] || attribs[:mail]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :email )
      attribs    = tidy_attribs(attribs)

      answer     = []

      command    = {action: 'create', scope: 'Users', attribute: 'mail'}
      user_attrs = attribs.merge(command)
      answer    << dscl( user_attrs, dir_info )

      command    = {action: 'create', scope: 'Users', attribute: 'email'}
      user_attrs = attribs.merge(command)
      answer    << dscl( user_attrs, dir_info )

      command    = {action: 'create', scope: 'Users', attribute: 'apple-user-mailattribute'}
      user_attrs = attribs.merge(command)
      answer    << dscl( user_attrs, dir_info )

      return answer
    end


    # dscl . -delete /Users/yourUserName
    # https://tutorialforlinux.com/2011/09/15/delete-users-and-groups-from-terminal/
    def user_delete(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'delete', scope: 'Users', value: nil, attribute: nil}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # https://images.apple.com/server/docs/Command_Line.pdf
    # https://serverfault.com/questions/20702/how-do-i-create-user-accounts-from-the-terminal-in-mac-os-x-10-5?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    # https://superuser.com/questions/1154564/how-to-create-a-user-from-the-macos-command-line
    def user_create_min(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', value: nil, attribute: nil}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # https://images.apple.com/server/docs/Command_Line.pdf
    # https://serverfault.com/questions/20702/how-do-i-create-user-accounts-from-the-terminal-in-mac-os-x-10-5?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    # https://superuser.com/questions/1154564/how-to-create-a-user-from-the-macos-command-line
    def user_create_full(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      attribs    = tidy_attribs(attribs).dup

      answer          = []
      attribs[:value] = nil
      answer         << user_create_min(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_password(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_shell(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_real_name(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_first_name(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_last_name(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_unique_id(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_primary_group_id(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_nfs_home_directory(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_email(attribs, dir_info)

      return answer.flatten
    end

    # ADD USER TO GROUPS
    ####################
    # http://krypted.com/mac-os-x/create-groups-using-dscl/
    # https://superuser.com/questions/214004/how-to-add-user-to-a-group-from-mac-os-x-command-line?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    # sudo dseditgroup -o edit -a $username_to_add -t user admin
    # sudo dseditgroup -o edit -a $username_to_add -t user wheel
    # http://osxdaily.com/2007/10/29/how-to-add-a-user-from-the-os-x-command-line-works-with-leopard/
    #
    # add 1st user   -- dscl . -create /Groups/ladmins GroupMembership localadmin
    # add more users -- dscl . -append /Groups/ladmins GroupMembership 2ndlocaladmin
    def user_add_to_group(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:user_shell]
      attribs[:value] = attribs[:value] || attribs[:shell]
      attribs[:value] = attribs[:value] || '/bin/bash'

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :shell )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'loginShell'}
      user_attrs  = attribs.merge(command)

      dscl( user_attrs, dir_info )

      # check_critical_attribute( attribs, :record_name, :user_add_to_group )
      # user_attrs = tidy_attribs(attribs)
      #
      # answer  = add_dscl_info( dir_info, attribs[:format] )
      # answer += %Q[ -append /Groups/#{user_attrs[:group_name]} GroupMembership #{user_attrs[:record_name]}]
      #
      # raise ArgumentError, "group blank" if user_attrs[:group_name].to_s.eql? ''
      # return answer
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$VALUE GroupMembership $shortname_USERNAME
    def user_remove_from_group(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:user_shell]
      attribs[:value] = attribs[:value] || attribs[:shell]
      attribs[:value] = attribs[:value] || '/bin/bash'

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :shell )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'loginShell'}
      user_attrs  = attribs.merge(command)

      dscl( user_attrs, dir_info )

      # check_critical_attribute( attribs, :record_name, :user_remove_from_group )
      # user_attrs = tidy_attribs(attribs)
      #
      # answer  = add_dscl_info( dir_info, attribs[:format] )
      # answer += %Q[ -delete /Groups/#{user_attrs[:group_name]} GroupMembership #{user_attrs[:record_name]}]
      #
      # raise ArgumentError, "group blank" if user_attrs[:group_name].to_s.eql? ''
      # return answer
    end
    # 1st keyword    -- /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-keyword "$VALUE"
    # other keywords --  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_keywords
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_add_keywords
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME mobile "$VALUE"
    def user_set_mobile_phone
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME telephoneNumber "$VALUE"
    def user_set_work_phone
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME homePhone "$VALUE"
    def user_set_home_phone
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-company "$VALUE"
    def user_set_company
    end
    alias_method :las_program_info, :user_set_company

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME title "$VALUE"
    def user_set_title
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME departmentNumber "$VALUE"
    def user_set_department
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME street "$VALUE"
    def user_set_street
    end
    alias_method :las_set_dorm, :user_set_street
    alias_method :las_set_housing, :user_set_street

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname l "$VALUE"
    def user_set_city
    end
    alias_method :las_, :user_set_city

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME st "$VALUE"
    def user_set_state
    end
    alias_method :las_cultural_trip, :user_set_state

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME postalCode "$VALUE"
    def user_set_postcode
    end
    alias_method :las_faculty_family, :user_set_postcode

    #  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER c "$VALUE"
    def user_set_country
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-webloguri "$VALUE"
    def user_set_blog
    end
    alias_method :user_set_weblog, :user_set_blog
    alias_method :las_sync_date, :user_set_blog

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-organizationinfo "$VALUE"
    def user_set_org_info
    end
    alias_method :las_set_organizational_info, :user_set_org_info
    alias_method :las_link_student_to_parent, :user_set_org_info

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-relationships "$VALUE"
    def user_set_relationships
    end
    alias_method :las_link_parent_to_student, :user_set_relationships

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER apple-imhandle "$VALUE"
    # others - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$USER apple-imhandle "ICQ:start: $START"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$USER apple-imhandle "MSN:end: $END"
    def user_set_chat
    end
    alias_method :user_set_chat_channels, :user_set_chat
    alias_method :las_created_date, :user_set_chat
    alias_method :las_start_date, :user_set_chat
    alias_method :las_end_date, :user_set_chat


    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME labeledURI "$VALUE"
    def user_set_homepage
    end
    alias_method :user_set_webpage, :user_set_homepage
    alias_method :las_enrollment_date, :user_set_homepage
    alias_method :las_begin_date, :user_set_homepage

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER description "$NAME"
    def user_set_comments
    end
    alias_method :user_set_description, :user_set_comments

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER description "$NAME"
    def user_comments
    end
    alias_method :user_description, :user_comments

  end
end
