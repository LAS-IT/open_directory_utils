module OpenDirectoryUtils

  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module UserActions

    def check_uid(action, attribs)
      attribs[:uid] = attribs[:uid]&.strip
      answer = send(action, attribs)
      raise ArgumentError, "missing uid"   if attribs[:uid].nil?
      raise ArgumentError, "blank uid"     if attribs[:uid].empty?
      raise ArgumentError, "uid has space" if attribs[:uid].include?(' ')
      return answer
    end

    # GET INFO
    ##########
    # get user record -- dscl . -read /Users/<username>
    # get user value  -- dscl . -read /Users/<username> <key>
    # search od user  -- dscl . -search /Users RealName "Andrew Garrett"
    # return as xml   -- dscl -plist . -search /Users RealName "Andrew Garrett"
    def user_get_info(attribs)
      "-read /Users/#{attribs[:uid]}"
    end

    # get all usernames -- dscl . -list /Users
    # get all user details -- dscl . -readall /Users
    def user_exists?(attribs)
      user_get_info(attribs)
    end


    # CHANGE OD
    ###########

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER RealName "$VALUE"
    def user_od_set_real_name(attribs)
      # %Q{-create /Users/#{attribs[:uid]} RealName "#{attribs[:]}"}
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER cn "$NAME"
    def user_ldap_set_common_name
    end


    # sudo dscl . -create /Users/someuser UniqueID "1010"  #use something not already in use
    def user_set_unique_id
    end

    # sudo dscl . -create /Users/someuser PrimaryGroupID 80
    def user_set_primary_group_id
    end

    # /usr/bin/dscl -plist -u diradmin -P #{adminpw} /LDAPv3/127.0.0.1/ -passwd /Users/#{uid} #{passwd}
    def user_set_password
    end

    # /usr/bin/dscl /LDAPv3/127.0.0.1 auth #{uid} #{passwd}
    def user_test_password
    end

    # /usr/bin/pwpolicy -a diradmin -p A-B1g-S3cret -u $UID_USERNAME -setpolicy "isDisabled=0"
    def user_enable_login
    end

    # /usr/bin/pwpolicy -a diradmin -p A-B1g-S3cret -u $UID_USERNAME -setpolicy "isDisabled=1"
    def user_disable_login
    end


    # https://images.apple.com/server/docs/Command_Line.pdf
    # https://serverfault.com/questions/20702/how-do-i-create-user-accounts-from-the-terminal-in-mac-os-x-10-5?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    # https://superuser.com/questions/1154564/how-to-create-a-user-from-the-macos-command-line
    # There are a few steps to create a user account from the command line. The good news is that you're using the right tool, dscl. What you're missing are the separate components that comprise a user account. You have to create these manually.
    # sudo dscl . -create /Users/someuser
    # sudo dscl . -create /Users/someuser UserShell /bin/bash
    # sudo dscl . -create /Users/someuser RealName "Lucius Q. User"
    # sudo dscl . -create /Users/someuser UniqueID "1010"  #use something not already in use
    # sudo dscl . -create /Users/someuser PrimaryGroupID 80
    # sudo dscl . -create /Users/someuser NFSHomeDirectory /Users/soemuser
    # SET PASSWOR use:
    # sudo dscl . -passwd /Users/someuser password
    # SET USER GROUP (optional, but recommended - student / employee or whatever you have):
    # sudo dscl . -append /Groups/admin GroupMembership someuser
    def user_create
    end

    # LDAP Fields
    #############
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER uidnumber "$VALUE"
    def user_set_uidnumber
    end

    # add 1st user   -- dscl . create /Groups/ladmins GroupMembership localadmin
    # add more users -- dscl . append /Groups/ladmins GroupMembership 2ndlocaladmin
    def user_add_to_group
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$VALUE GroupMembership $UID_USERNAME
    def user_remove_from_group
    end

    # dscl . -delete /Users/yourUserName
    # https://tutorialforlinux.com/2011/09/15/delete-users-and-groups-from-terminal/
    def user_delete
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME gidnumber "$VALUE"
    def user_set_groupnumber
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME ??? "$VALUE"
    def user_set_saluation
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME givenName "$VALUE"
    def user_set_first_name
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME ??? "$VALUE"
    def user_set_middle_name
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME sn "$VALUE"
    def user_set_last_name
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME NameSuffix "$VALUE"
    def user_set_name_suffix
    end


    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-namesuffix "$VALUE"
    def user_set_name_suffix
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME mail "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME email "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-user-mailattribute "$VALUE"
    def user_set_email
    end

    # 1st keyword    -- /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-keyword "$VALUE"
    # other keywords --  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$UID_USERNAME apple-keyword "$VALUE"
    def user_set_keywords
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$UID_USERNAME apple-keyword "$VALUE"
    def user_add_keywords
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME mobile "$VALUE"
    def user_set_mobile_phone
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME telephoneNumber "$VALUE"
    def user_set_work_phone
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME homePhone "$VALUE"
    def user_set_home_phone
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-company "$VALUE"
    def user_set_company
    end
    alias_method :las_program_info, :user_set_company

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME title "$VALUE"
    def user_set_title
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME departmentNumber "$VALUE"
    def user_set_department
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME homedirectory "$VALUE"
    def user_set_home_directoy
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME loginShell "$VALUE"
    def user_set_login_shell
    end
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME street "$VALUE"
    def user_set_street
    end
    alias_method :las_set_dorm, :user_set_street
    alias_method :las_set_housing, :user_set_street

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID l "$VALUE"
    def user_set_city
    end
    alias_method :las_, :user_set_city

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME st "$VALUE"
    def user_set_state
    end
    alias_method :las_cultural_trip, :user_set_state

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME postalCode "$VALUE"
    def user_set_postcode
    end
    alias_method :las_faculty_family, :user_set_postcode

    #  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$USER c "$VALUE"
    def user_set_country
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-webloguri "$VALUE"
    def user_set_blog
    end
    alias_method :user_set_weblog, :user_set_blog
    alias_method :las_sync_date, :user_set_blog

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-organizationinfo "$VALUE"
    def user_set_org_info
    end
    alias_method :las_set_organizational_info, :user_set_org_info
    alias_method :las_link_student_to_parent, :user_set_org_info

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-relationships "$VALUE"
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


    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME labeledURI "$VALUE"
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
