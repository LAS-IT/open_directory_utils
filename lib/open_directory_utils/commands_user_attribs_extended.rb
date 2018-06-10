require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"
require "open_directory_utils/commands_base"

module OpenDirectoryUtils

  # this is a long list of pre-built dscl commands affecting users to accomplish common actions
  # @note - these commands were derived from the following resrouces:
  # * https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # * https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsUserAttribsExtended

    # include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck
    include OpenDirectoryUtils::CommandsBase

    # 1st keyword    -- /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-keyword "$VALUE"
    # other keywords --  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_first_keyword
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_append_keyword
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-company "$VALUE"
    def user_set_company
    end
    alias_method :las_program_info, :user_set_company

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "$VALUE"
    # others - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "ICQ:start: $START"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "MSN:end: $END"
    def user_set_chat
    end
    alias_method :user_set_chat_channels, :user_set_chat
    alias_method :las_created_date, :user_set_chat
    alias_method :las_start_date, :user_set_chat
    alias_method :las_end_date, :user_set_chat

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-webloguri "$VALUE"
    def user_set_blog
    end
    alias_method :user_set_weblog, :user_set_blog
    alias_method :las_sync_date, :user_set_blog

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-organizationinfo "$VALUE"
    def user_set_org_info
    end
    alias_method :las_set_organizational_info, :user_set_org_info
    alias_method :las_link_student_to_parent, :user_set_org_info

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-relationships "$VALUE"
    def user_set_relationships
    end
    alias_method :las_link_parent_to_student, :user_set_relationships


  end
end
