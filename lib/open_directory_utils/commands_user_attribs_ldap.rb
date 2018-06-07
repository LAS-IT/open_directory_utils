require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"
require "open_directory_utils/commands_base"

module OpenDirectoryUtils

  # this is a long list of pre-built dscl commands affecting users to accomplish common actions
  # @note - these commands were derived from the following resrouces:
  # * https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # * https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsUserAttribsLdap

    # include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck
    include OpenDirectoryUtils::CommandsBase

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER cn "$NAME"
    def user_set_common_name(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:cn]
      attribs[:value] = attribs[:value] || attribs[:realname]
      attribs[:value] = attribs[:value] || attribs[:real_name]
      attribs[:value] = attribs[:value] || attribs[:fullname]
      attribs[:value] = attribs[:value] || attribs[:full_name]
      attribs[:value] = attribs[:value] || "#{attribs[:first_name]} #{attribs[:last_name]}"

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :common_name )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'cn'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_cn, :user_set_common_name

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

      answer          = []
      attribs[:value] = nil
      answer         << dscl( user_attrs, dir_info )
      attribs[:value] = nil
      answer         << user_set_password(attribs, dir_info)
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
      attribs    = tidy_attribs(attribs).dup

      answer          = []
      attribs[:value] = nil
      answer         << user_create_min(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_shell(attribs, dir_info)
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
      # skip email if non-sent
      unless attribs[:email].nil? and attribs[:mail].nil? and attribs[:apple_user_mailattribute].nil?
        attribs[:value] = nil
        answer         << user_set_email(attribs, dir_info)
      end

      return answer.flatten
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

  end
end
