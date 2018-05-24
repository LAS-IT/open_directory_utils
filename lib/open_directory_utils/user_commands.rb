module OpenDirectoryUtils
  module UserCommands

    def user_exists?
    end

    def user_get_info
    end

    def user_create
    end

    def user_add_to_group
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$VALUE GroupMembership $UID_USERNAME
    def user_remove_from_group
    end

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
