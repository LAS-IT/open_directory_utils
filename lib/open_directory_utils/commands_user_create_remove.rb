# require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"
require "open_directory_utils/commands_base"
require "open_directory_utils/commands_groups"
require "open_directory_utils/commands_user_attribs"

module OpenDirectoryUtils

  # this is a long list of pre-built dscl commands affecting users to accomplish common actions
  # @note - these commands were derived from the following resrouces:
  # * https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dscl.1.html
  # * https://superuser.com/questions/592921/mac-osx-users-vs-dscl-command-to-list-user/621055?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsUserCreateRemove

    # include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck
    include OpenDirectoryUtils::CommandsBase
    include OpenDirectoryUtils::CommandsGroups
    include OpenDirectoryUtils::CommandsUserAttribs

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
      answer         << user_set_shell(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_last_name(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_real_name(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_unique_id(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_primary_group_id(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_set_nfs_home_directory(attribs, dir_info)
      attribs[:value] = nil
      answer         << user_enable_login(attribs, dir_info)      if
                        attribs[:enable]&.eql? 'true' or attribs[:enable]&.eql? true
      answer         << user_disable_login(attribs, dir_info) unless
                        attribs[:enable]&.eql? 'true' or attribs[:enable]&.eql? true
      return answer
    end

    # https://images.apple.com/server/docs/Command_Line.pdf
    # https://serverfault.com/questions/20702/how-do-i-create-user-accounts-from-the-terminal-in-mac-os-x-10-5?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    # https://superuser.com/questions/1154564/how-to-create-a-user-from-the-macos-command-line
    def user_create(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      # attribs           = tidy_attribs(attribs).dup
      attribs           = tidy_attribs(attribs)

      answer            = []
      attribs[:value]   = nil
      answer           << user_create_min(attribs, dir_info)
      if attribs[:first_name] or attribs[:firstname] or attribs[:given_name] or
                          attribs[:givenname]
        attribs[:value] = nil
        answer         << user_set_first_name(attribs, dir_info)
      end
      if attribs[:email] or attribs[:mail] or attribs[:apple_user_mailattribute]
        attribs[:value] = nil
        answer         << user_set_email(attribs, dir_info)
      end
      if attribs[:relations] or attribs[:relationships]
        attribs[:value] = nil
        answer         << user_set_relationships(attribs, dir_info)
      end
      if attribs[:org_info] or attribs[:organization_info]
        attribs[:value] = nil
        answer         << user_set_organization_info(attribs, dir_info)
      end
      if attribs[:title]
        attribs[:value] = nil
        answer         << user_set_title(attribs, dir_info)
      end
      if attribs[:department] or attribs[:departmentnumber] or attribs[:department_number]
        attribs[:value] = nil
        answer         << user_set_department(attribs, dir_info)
      end
      if attribs[:company]
        attribs[:value] = nil
        answer         << user_set_company(attribs, dir_info)
      end
      if attribs[:address]
        attribs[:value] = nil
        answer         << user_set_address(attribs, dir_info)
      end
      if attribs[:city] or attribs[:town]
        attribs[:value] = nil
        answer         << user_set_city(attribs, dir_info)
      end
      if attribs[:state]
        attribs[:value] = nil
        answer         << user_set_state(attribs, dir_info)
      end
      if attribs[:country]
        attribs[:value] = nil
        answer         << user_set_country(attribs, dir_info)
      end
      if attribs[:keyword] or attribs[:keywords]
        attribs[:value] = nil
        answer         << user_set_keywords(attribs, dir_info)
      end
      if attribs[:group_name] or attribs[:groupname] or attribs[:gid] or
                        attribs[:group_membership] or attribs[:groupmembership]
        attribs[:value] = nil
        answer         << user_add_to_group(attribs, dir_info)
      end

      return answer.flatten
    end

    def user_update(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )
      # attribs           = tidy_attribs(attribs).dup
      attribs           = tidy_attribs(attribs)

      answer            = []
      if attribs[:shell]
        attribs[:value] = nil
        answer         << user_set_shell(attribs, dir_info)
      end
      if attribs[:last_name] or attribs[:lastname] or attribs[:surname] or attribs[:sn]
        attribs[:value] = nil
        answer         << user_set_last_name(attribs, dir_info)
      end
      if attribs[:real_name] or attribs[:realname] or attribs[:fullname]
        attribs[:value] = nil
        answer         << user_set_real_name(attribs, dir_info)
      end
      if attribs[:unique_id] or attribs[:uniqueid] or attribs[:uidnumber]
        attribs[:value] = nil
        answer         << user_set_unique_id(attribs, dir_info)
      end
      if attribs[:primary_group_id] or attribs[:primarygroupid] or
          attribs[:group_id] or attribs[:groupid] or attribs[:gidnumber]
        attribs[:value] = nil
        answer         << user_set_primary_group_id(attribs, dir_info)
      end
      if attribs[:nfs_home_directory] or attribs[:home_directory]
        attribs[:value] = nil
        answer         << user_set_nfs_home_directory(attribs, dir_info)
      end
      if attribs[:first_name] or attribs[:firstname] or attribs[:given_name] or
                          attribs[:givenname]
        attribs[:value] = nil
        answer         << user_set_first_name(attribs, dir_info)
      end
      if attribs[:email] or attribs[:mail]
        attribs[:value] = nil
        answer         << user_set_email(attribs, dir_info)
      end
      if attribs[:relations] or attribs[:relationships]
        attribs[:value] = nil
        answer         << user_set_relationships(attribs, dir_info)
      end
      if attribs[:org_info] or attribs[:organization_info]
        attribs[:value] = nil
        answer         << user_set_organization_info(attribs, dir_info)
      end
      if attribs[:title] or attribs[:job_title]
        attribs[:value] = nil
        answer         << user_set_title(attribs, dir_info)
      end
      if attribs[:department] or attribs[:departmentnumber] or attribs[:department_number]
        attribs[:value] = nil
        answer         << user_set_department(attribs, dir_info)
      end
      if attribs[:company]
        attribs[:value] = nil
        answer         << user_set_company(attribs, dir_info)
      end
      if attribs[:address]
        attribs[:value] = nil
        answer         << user_set_address(attribs, dir_info)
      end
      if attribs[:city] or attribs[:town]
        attribs[:value] = nil
        answer         << user_set_city(attribs, dir_info)
      end
      if attribs[:state]
        attribs[:value] = nil
        answer         << user_set_state(attribs, dir_info)
      end
      if attribs[:postal_code] or attribs[:zip_code] or attribs[:zip]
        attribs[:value] = nil
        answer         << user_set_postal_code(attribs, dir_info)
      end
      if attribs[:country]
        attribs[:value] = nil
        answer         << user_set_country(attribs, dir_info)
      end
      if attribs[:home_page] or attribs[:homepage] or
          attribs[:web_page] or attribs[:webpage] or attribs[:url]
        attribs[:value] = nil
        answer         << user_set_home_page(attribs, dir_info)
      end
      if attribs[:keyword] or attribs[:keywords]
        attribs[:value] = nil
        answer         << user_set_keywords(attribs, dir_info)
      end
      if attribs[:weblog] or attribs[:blog]
        attribs[:value] = nil
        answer         << user_set_weblog(attribs, dir_info)
      end

      return answer.flatten
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

  end
end
