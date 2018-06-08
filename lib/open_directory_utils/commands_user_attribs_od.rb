require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"
require "open_directory_utils/commands_base"

module OpenDirectoryUtils

  # this is a long list of pre-built dscl commands affecting users to accomplish common actions
  # @note - these commands were derived from the following resrouces:
  # * https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # * https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsUserAttribsOd

    # include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck
    include OpenDirectoryUtils::CommandsBase

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

      attribs[:value] = attribs[:value] || attribs[:common_name]
      attribs[:value] = attribs[:value] || attribs[:cn]
      attribs[:value] = attribs[:value] || attribs[:realname]
      attribs[:value] = attribs[:value] || attribs[:real_name]
      attribs[:value] = attribs[:value] || attribs[:fullname]
      attribs[:value] = attribs[:value] || attribs[:full_name]
      if attribs[:last_name] or attribs[:first_name]
        attribs[:value] = attribs[:value] || "#{attribs[:first_name]} #{attribs[:last_name]}"
      end
      attribs[:value] = attribs[:value] || attribs[:record_name]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :real_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'RealName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME FirstName "$VALUE"
    def user_set_first_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:given_name]
      attribs[:value] = attribs[:value] || attribs[:givenname]
      attribs[:value] = attribs[:value] || attribs[:first_name]
      attribs[:value] = attribs[:value] || attribs[:firstname]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :first_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'FirstName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME LastName "$VALUE"
    def user_set_last_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:sn]
      attribs[:value] = attribs[:value] || attribs[:surname]
      attribs[:value] = attribs[:value] || attribs[:lastname]
      attribs[:value] = attribs[:value] || attribs[:last_name]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :last_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'LastName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

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
      attribs[:value] = attribs[:value] || attribs[:usernumber]
      attribs[:value] = attribs[:value] || attribs[:user_number]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :unique_id )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'UniqueID'}
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

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME mail "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME email "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-user-mailattribute "$VALUE"
    def user_set_first_email(attribs, dir_info)
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
    alias_method :user_set_email, :user_set_first_email

    def user_append_email(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs['apple-user-mailattribute']
      attribs[:value] = attribs[:value] || attribs[:apple_user_mailattribute]
      attribs[:value] = attribs[:value] || attribs[:email]
      attribs[:value] = attribs[:value] || attribs[:mail]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :email )
      attribs    = tidy_attribs(attribs)

      answer     = []

      command    = {action: 'append', scope: 'Users', attribute: 'mail'}
      user_attrs = attribs.merge(command)
      answer    << dscl( user_attrs, dir_info )

      command    = {action: 'append', scope: 'Users', attribute: 'email'}
      user_attrs = attribs.merge(command)
      answer    << dscl( user_attrs, dir_info )

      return answer
    end

    # sudo dscl . -create /Users/someuser PrimaryGroupID 80
    def user_set_primary_group_id(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:groupid]
      attribs[:value] = attribs[:value] || attribs[:group_id]
      attribs[:value] = attribs[:value] || attribs[:gidnumber]
      attribs[:value] = attribs[:value] || attribs[:groupnumber]
      attribs[:value] = attribs[:value] || attribs[:group_number]
      attribs[:value] = attribs[:value] || attribs[:primarygroupid]
      attribs[:value] = attribs[:value] || attribs[:primary_group_id]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :group_id )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'PrimaryGroupID'}
      user_attrs = attribs.merge(command)

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
    def user_password_verified?(attribs, dir_info)
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
    alias_method :user_password_ok?, :user_password_verified?

    # /usr/bin/pwpolicy -a diradmin -p A-B1g-S3cret -u $shortname_USERNAME -setpolicy "isDisabled=0"
    def user_enable_login(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      attribs    = tidy_attribs(attribs)

      command = {attribute: 'enableuser', value: nil}
      params  = command.merge(attribs)
      pwpolicy(params, dir_info)
    end
    # /usr/bin/pwpolicy -a diradmin -p A-B1g-S3cret -u $shortname_USERNAME -setpolicy "isDisabled=1"
    def user_disable_login(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      attribs    = tidy_attribs(attribs)

      command = {attribute: 'disableuser', value: nil}
      params  = command.merge(attribs)
      pwpolicy(params, dir_info)
    end

    # /usr/bin/pwpolicy -a diradmin -p A-B1g-S3cret -u $shortname_USERNAME -getpolicy
    def user_get_policy(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      attribs    = tidy_attribs(attribs)

      command = {attribute: 'getpolicy', value: nil}
      params  = command.merge(attribs)
      pwpolicy(params, dir_info)
    end
    alias_method :user_login_enabled?,  :user_get_policy

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

      answer          = []
      attribs[:value] = nil
      answer         << dscl( user_attrs, dir_info )
      attribs[:value] = nil
      answer         << user_set_password(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_enable_login(attribs, dir_info)      if
                        attribs[:enable]&.eql? 'true' or attribs[:enable]&.eql? true
      answer         << user_disable_login(attribs, dir_info) unless
                        attribs[:enable]&.eql? 'true' or attribs[:enable]&.eql? true
      attribs[:value] = nil
      answer         << user_set_real_name(attribs, dir_info)

      return answer
    end

    # https://images.apple.com/server/docs/Command_Line.pdf
    # https://serverfault.com/questions/20702/how-do-i-create-user-accounts-from-the-terminal-in-mac-os-x-10-5?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    # https://superuser.com/questions/1154564/how-to-create-a-user-from-the-macos-command-line
    def user_create_full(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      # attribs           = tidy_attribs(attribs).dup
      attribs           = tidy_attribs(attribs)

      answer            = []
      attribs[:value]   = nil
      answer           << user_create_min(attribs, dir_info)
      attribs[:value]   = nil
      answer           << user_set_shell(attribs, dir_info)
      if attribs[:first_name] or attribs[:firstname] or attribs[:given_name] or
                          attribs[:givenname]
        attribs[:value] = nil
        answer         << user_set_first_name(attribs, dir_info)
      end
      if attribs[:last_name] or attribs[:lastname] or attribs[:sn] or
                          attribs[:surname]
        attribs[:value] = nil
        answer         << user_set_last_name(attribs, dir_info)
      end
      attribs[:value]   = nil
      answer           << user_set_unique_id(attribs, dir_info)
      attribs[:value]   = nil
      answer           << user_set_primary_group_id(attribs, dir_info)
      attribs[:value]   = nil
      answer           << user_set_nfs_home_directory(attribs, dir_info)
      # skip email if non-sent
      if attribs[:email] or attribs[:mail] or attribs[:apple_user_mailattribute]
        attribs[:value] = nil
        answer         << user_set_email(attribs, dir_info)
      end
      # TODO add to groups without error - if group present
      # "<main> attribute status: eDSSchemaError\n" +
      # "<dscl_cmd> DS Error: -14142 (eDSSchemaError)"]
      # # enroll in a group membership if info present
      # if attribs[:group_name] or attribs[:groupname] or attribs[:gid] or
      #                   attribs[:group_membership] or attribs[:groupmembership]
      #   attribs[:value] = nil
      #   answer         << user_set_group_memebership(attribs, dir_info)
      # end

      return answer.flatten
    end
    alias_method :user_create, :user_create_full

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

    # 1st keyword    -- /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-keyword "$VALUE"
    # other keywords --  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_first_keyword
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_append_keyword
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$shortname_USERNAME apple-company "$VALUE"
    def user_set_company
    end
    alias_method :las_program_info, :user_set_company

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


  end
end
