module OpenDirectoryUtils
  # command pattern
  # https://makandracards.com/alexander-m/43748-command-pattern
  # https://stackoverflow.com/questions/43535421/command-pattern-in-ruby?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  #
  # DSCL
  # https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  class Commands
    class Error < StandardError; end

    def initialize(params)
    end

    def execute
      raise NotYetImplemented
    end
  end

  # # get all usernames -- dscl . -list /Users
  # # get all user details -- dscl . -readall /Users
  # def user_exists?
  # end
  class UserGetInfo
    # get user record -- dscl . -read /Users/<username>
    # get user value  -- dscl . -read /Users/<username> <key>
    # search od user  -- dscl . -search /Users RealName "Andrew Garrett"
    # return as xml   -- dscl -plist . -search /Users RealName "Andrew Garrett"
    def user_get_info
    end
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
    #
    # You can then use passwd to change the user's password, or use:
    # sudo dscl . -passwd /Users/someuser password

    # You'll also have to create the user's home directory and change ownership so the user can access it. And be sure that the UniqueID is, in fact, unique.
    #
    # This line will add the user to the administrator's group:
    # sudo dscl . -append /Groups/admin GroupMembership someuser
    def user_create
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

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME gidnumber "$VALUE"
    def user_set_groupnumber
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME givenName "$VALUE"
    def user_set_first_name
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME sn "$VALUE"
    def user_set_last_name
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-namesuffix "$VALUE"
    def user_set_name_suffix
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME mail "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME email "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-user-mailattribute "$VALUE"
    def user_set_email
    end

    # create first keyword
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-keyword "$VALUE"
    # add a keyword
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -append /Users/$UID_USERNAME apple-keyword "$VALUE"
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

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME title "$VALUE"
    def user_set_title
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME homedirectory "$VALUE"
    def user_set_home_directoy
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME loginShell "$VALUE"
    def user_set_shell
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-company "$VALUE"
    def user_set_company
    end
    alias_method :las_program_info, :user_set_company

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME street "$VALUE"
    def user_set_street
    end
    alias_method :las_, :user_set_street

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

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-webloguri "$VALUE"
    def user_set_blog
    end
    alias_method :las_, :user_set_blog

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-organizationinfo "$VALUE"
    def user_organizational_info
    end
    alias_method :las_link_student_to_parent, :user_organizational_info

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME apple-relationships "$VALUE"
    def user_relationships
    end
    alias_method :las_link_parent_to_student, :user_relationships

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -create /Users/$UID_USERNAME labeledURI "$VALUE"
    def user_set_homepage
    end
    alias_method :las_enrollment_date, :user_set_homepage
    alias_method :las_start_date, :user_set_homepage

  end
end
