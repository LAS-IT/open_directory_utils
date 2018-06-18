# require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"
require "open_directory_utils/commands_base"

module OpenDirectoryUtils

  # this is a long list of pre-built dscl commands affecting users to accomplish common actions
  # @note - these commands were derived from the following resrouces:
  # * https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # * https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsUserAttribs

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
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER RealName "$VALUE"
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

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME FirstName "$VALUE"
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

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME LastName "$VALUE"
    def user_set_last_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:sn]
      attribs[:value] = attribs[:value] || attribs[:surname]
      attribs[:value] = attribs[:value] || attribs[:lastname]
      attribs[:value] = attribs[:value] || attribs[:last_name]
      attribs[:value] = attribs[:value] || attribs[:real_name]
      attribs[:value] = attribs[:value] || attribs[:realname]
      attribs[:value] = attribs[:value] || attribs[:short_name]
      attribs[:value] = attribs[:value] || attribs[:shortname]
      attribs[:value] = attribs[:value] || attribs[:user_name]
      attribs[:value] = attribs[:value] || attribs[:username]
      attribs[:value] = attribs[:value] || attribs[:uid]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :last_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'LastName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # sudo dscl . -create /Users/someuser UniqueID "1010"
    def user_set_unique_id(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:uniqueid]
      attribs[:value] = attribs[:value] || attribs[:unique_id]
      attribs[:value] = attribs[:value] || attribs[:uid_number]
      attribs[:value] = attribs[:value] || attribs[:uidnumber]
      attribs[:value] = attribs[:value] || attribs[:usernumber]
      attribs[:value] = attribs[:value] || attribs[:user_number]

      check_critical_attribute( attribs, :value, :unique_id )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'UniqueID'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/someuser NFSHomeDirectory /Users/someuser
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

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME mail "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME email "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-user-mailattribute "$VALUE"
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

      command    = {action: 'create', scope: 'Users', attribute: 'MailAttribute'}
      user_attrs = attribs.merge(command)
      answer    << dscl( user_attrs, dir_info )

      command    = {action: 'create', scope: 'Users', attribute: 'EMailAddress'}
      user_attrs = attribs.merge(command)
      answer    << dscl( user_attrs, dir_info )

      # command    = {action: 'create', scope: 'Users', attribute: 'apple-user-mailattribute'}
      # user_attrs = attribs.merge(command)
      # answer    << dscl( user_attrs, dir_info )

      return answer
    end
    alias_method :user_set_email, :user_set_first_email

    def user_append_email(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs['apple-user-mailattribute']
      attribs[:value] = attribs[:value] || attribs[:apple_user_mailattribute]
      attribs[:value] = attribs[:value] || attribs[:e_mail_attribute]
      attribs[:value] = attribs[:value] || attribs[:mail_attribute]
      attribs[:value] = attribs[:value] || attribs[:email]
      attribs[:value] = attribs[:value] || attribs[:mail]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :email )
      attribs    = tidy_attribs(attribs)

      answer     = []

      # command    = {action: 'append', scope: 'Users', attribute: 'mail'}
      # user_attrs = attribs.merge(command)
      # answer    << dscl( user_attrs, dir_info )

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
    # /usr/bin/dscl -plist -u diradmin -P #{adminpw} /LDAPv3/127.0.0.1 -passwd /Users/#{shortname} "#{passwd}"
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

    def user_add_to_group(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:group_membership]
      attribs[:value] = attribs[:value] || attribs[:groupmembership]
      attribs[:value] = attribs[:value] || attribs[:group_name]
      attribs[:value] = attribs[:value] || attribs[:groupname]
      attribs[:value] = attribs[:value] || attribs[:gid]

      check_critical_attribute( attribs, :record_name, :username )
      check_critical_attribute( attribs, :value, :groupname )
      attribs    = tidy_attribs(attribs)
      command    = { operation: 'edit', action: 'add', type: 'user'}
      user_attrs  = attribs.merge(command)

      dseditgroup( user_attrs, dir_info )
    end

    def user_remove_from_group(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:group_membership]
      attribs[:value] = attribs[:value] || attribs[:groupmembership]
      attribs[:value] = attribs[:value] || attribs[:group_name]
      attribs[:value] = attribs[:value] || attribs[:groupname]
      attribs[:value] = attribs[:value] || attribs[:gid]

      check_critical_attribute( attribs, :record_name, :username )
      check_critical_attribute( attribs, :value, :groupname )
      attribs    = tidy_attribs(attribs)
      command    = { operation: 'edit', action: 'delete', type: 'user'}
      user_attrs  = attribs.merge(command)

      dseditgroup( user_attrs, dir_info )
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

    def user_set_city(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:locale]
      attribs[:value] = attribs[:value] || attribs[:city]
      attribs[:value] = attribs[:value] || attribs[:town]
      attribs[:value] = attribs[:value] || attribs[:l]

      check_critical_attribute( attribs, :value, :city )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'City'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    def user_create_chat(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:im_handle]
      attribs[:value] = attribs[:value] || attribs[:imhandle]
      attribs[:value] = attribs[:value] || attribs[:handle]
      attribs[:value] = attribs[:value] || attribs[:chat]
      attribs[:value] = attribs[:value] || attribs[:im]

      check_critical_attribute( attribs, :value, :chat )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'IMHandle'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    def user_append_chat(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:im_handle]
      attribs[:value] = attribs[:value] || attribs[:imhandle]
      attribs[:value] = attribs[:value] || attribs[:handle]
      attribs[:value] = attribs[:value] || attribs[:chat]
      attribs[:value] = attribs[:value] || attribs[:im]

      check_critical_attribute( attribs, :value, :chat )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'append', scope: 'Users', attribute: 'IMHandle'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "$VALUE"
    # others - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "ICQ:start: $START"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "MSN:end: $END"
    def user_set_chat(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:values] = attribs[:values] || attribs[:im_handle]
      attribs[:values] = attribs[:values] || attribs[:imhandle]
      attribs[:values] = attribs[:values] || attribs[:handle]
      attribs[:values] = attribs[:values] || attribs[:chat]
      attribs[:values] = attribs[:values] || attribs[:im]

      answer = []
      Array(attribs[:values]).each_with_index do |value, index|
        attribs[:value] = value
        case index
        when 0
          answer << user_create_chat(attribs, dir_info)
        else
          answer << user_append_chat(attribs, dir_info)
        end
      end
      return answer  unless attribs[:values].nil? or attribs[:values].empty?
      raise ArgumentError, "values: '#{attribs[:values].inspect}' invalid, value_name: :chats"
    end
    alias_method :user_set_im_handle, :user_set_chat
    alias_method :user_set_chat_channels, :user_set_chat
    # alias_method :las_created_date, :user_set_chat
    # alias_method :las_start_date, :user_set_chat
    # alias_method :las_end_date, :user_set_chat


    def user_set_comment(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:description]
      attribs[:value] = attribs[:value] || attribs[:comment]

      check_critical_attribute( attribs, :value, :comment )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Comment'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_description, :user_set_comment

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-company "$VALUE"
    def user_set_company(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:company]

      check_critical_attribute( attribs, :value, :company )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Company'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # alias_method :las_program_info, :user_set_company

    def user_set_country(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:country]
      attribs[:value] = attribs[:value] || attribs[:c]

      check_critical_attribute( attribs, :value, :country )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Country'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_department(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:department_number]
      attribs[:value] = attribs[:value] || attribs[:departmentnumber]
      attribs[:value] = attribs[:value] || attribs[:dept_number]
      attribs[:value] = attribs[:value] || attribs[:deptnumber]
      attribs[:value] = attribs[:value] || attribs[:department]
      attribs[:value] = attribs[:value] || attribs[:dept]

      check_critical_attribute( attribs, :value, :department )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Department'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_job_title(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:job_title]
      attribs[:value] = attribs[:value] || attribs[:jobtitle]
      attribs[:value] = attribs[:value] || attribs[:title]

      check_critical_attribute( attribs, :value, :job_title )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'JobTitle'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_title, :user_set_job_title

    # 1st keyword    -- /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-keyword "$VALUE"
    # other keywords --  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_create_keyword(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:keywords]
      attribs[:value] = attribs[:value] || attribs[:keyword]

      check_critical_attribute( attribs, :value, :keyword )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Keywords'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_create_keywords, :user_create_keyword

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_append_keyword(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:keywords]
      attribs[:value] = attribs[:value] || attribs[:keyword]

      check_critical_attribute( attribs, :value, :keyword )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'append', scope: 'Users', attribute: 'Keywords'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_append_keywords, :user_append_keyword

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_keywords(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:values] = attribs[:values] || attribs[:keywords]
      attribs[:values] = attribs[:values] || attribs[:keyword]

      answer = []
      Array(attribs[:values]).each_with_index do |value, index|
        attribs[:value] = value

        case index
        when 0
          answer << user_create_keyword(attribs, dir_info)
        else
          answer << user_append_keyword(attribs, dir_info)
        end
      end
      return answer  unless attribs[:values].nil? or attribs[:values].empty?
      raise ArgumentError, "values: '#{attribs[:values].inspect}' invalid, value_name: :keywords"
    end
    alias_method :user_set_keyword, :user_set_keywords

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_home_phone(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:home_phone_number]
      attribs[:value] = attribs[:value] || attribs[:home_number]
      attribs[:value] = attribs[:value] || attribs[:home_phone]

      check_critical_attribute( attribs, :value, :home_phone )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'HomePhoneNumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_mobile_phone(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:mobile_phone_number]
      attribs[:value] = attribs[:value] || attribs[:mobile_number]
      attribs[:value] = attribs[:value] || attribs[:mobile_phone]

      check_critical_attribute( attribs, :value, :mobile_phone )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'MobileNumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_mobile_number, :user_set_mobile_phone
    alias_method :user_set_mobile_phone_number, :user_set_mobile_phone

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_work_phone(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:work_phone_number]
      attribs[:value] = attribs[:value] || attribs[:phone_number]
      attribs[:value] = attribs[:value] || attribs[:work_number]
      attribs[:value] = attribs[:value] || attribs[:work_phone]
      attribs[:value] = attribs[:value] || attribs[:number]
      attribs[:value] = attribs[:value] || attribs[:phone]

      check_critical_attribute( attribs, :value, :work_phone )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'PhoneNumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_name_suffix(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:name_suffix]
      attribs[:value] = attribs[:value] || attribs[:suffix]
      check_critical_attribute( attribs, :value, :name_suffix )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'NameSuffix'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_organization_info(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:organization_info]
      attribs[:value] = attribs[:value] || attribs[:organization]
      attribs[:value] = attribs[:value] || attribs[:org_info]
      attribs[:value] = attribs[:value] || attribs[:org]
      check_critical_attribute( attribs, :value, :organization_info )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'OrganizationInfo'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_org_info, :user_set_organization_info
    # alias_method :user_set_student_id, :user_set_organization_info

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-webloguri "$VALUE"
    def user_set_postal_code(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:postal_code]
      attribs[:value] = attribs[:value] || attribs[:post_code]
      attribs[:value] = attribs[:value] || attribs[:zip_code]
      attribs[:value] = attribs[:value] || attribs[:zip]
      check_critical_attribute( attribs, :value, :postal_code )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'PostalCode'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_post_code, :user_set_postal_code
    alias_method :user_set_zip_code, :user_set_postal_code
    # alias_method :las_sync_date, :user_set_weblog

    def user_set_relationships(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:relationships]
      attribs[:value] = attribs[:value] || attribs[:relations]
      check_critical_attribute( attribs, :value, :relationships )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Relationships'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_state(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:state]
      attribs[:value] = attribs[:value] || attribs[:st]
      check_critical_attribute( attribs, :value, :state )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'State'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_street(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:address]
      attribs[:value] = attribs[:value] || attribs[:street]
      check_critical_attribute( attribs, :value, :street )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Street'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_address, :user_set_street

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-webloguri "$VALUE"
    def user_set_weblog(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:weblog]
      attribs[:value] = attribs[:value] || attribs[:blog]
      check_critical_attribute( attribs, :value, :weblog )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'WeblogURI'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_blog, :user_set_weblog
    # alias_method :las_sync_date, :user_set_weblog

  end
end
