# require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"
require "open_directory_utils/commands_base"

module OpenDirectoryUtils

  # this is a long list of pre-built dscl commands affecting groups to accomplish common actions
  # @note - these commands were derived from the following resrouces:
  # * http://krypted.com/mac-os-x/create-groups-using-dscl/
  # * https://apple.stackexchange.com/questions/307173/creating-a-group-via-users-groups-in-command-line?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsGroups

    # include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck
    include OpenDirectoryUtils::CommandsBase

    # dscl . read /Groups/ladmins
    def group_get_info(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )

      command = {action: 'read', scope: 'Groups', value: nil}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :group_info, :group_get_info

    def group_exists?(attribs, dir_info)
      group_get_info(attribs, dir_info)
    end

    # dscl . -read /Groups/ladmins
    # TODO: switch to dseditgroup -o checkmember -m username groupname
    # dseditgroup -o checkmember -m btihen employee
    #   yes btihen is a member of employee
    # dseditgroup -o checkmember -m btihen student
    #   no btihen is NOT a member of student
    def user_in_group?(attribs, dir_info)
      temp       = user_record_name_alternatives(attribs)
      username   = temp[:record_name]
      # pp username
      # pp attribs

      attribs    = group_record_name_alternatives(attribs)
      # groupname  = attribs[:record_name]
      attribs[:value] = username
      # pp attribs

      check_critical_attribute( attribs, :value, :username )
      check_critical_attribute( attribs, :record_name, :groupname )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'read', scope: 'Groups', attribute: nil, value: nil}
      cmd_attribs = attribs.merge(command)

      dscl( cmd_attribs, dir_info )
    end

    # dscl . -delete /Groups/yourGroupName
    # https://tutorialforlinux.com/2011/09/15/delete-users-and-groups-from-terminal/
    def group_delete(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )

      command = {action: 'delete', scope: 'Groups', attribute: nil, value: nil}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def group_create_min(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      check_critical_attribute( attribs, :record_name )

      command = {action: 'create', scope: 'Groups', attribute: nil, value: nil}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def group_set_primary_group_id(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:primary_group_id]
      attribs[:value] = attribs[:value] || attribs[:group_number]
      attribs[:value] = attribs[:value] || attribs[:groupnumber]
      attribs[:value] = attribs[:value] || attribs[:gidnumber]
      attribs[:value] = attribs[:value] || attribs[:group_id]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :group_id )

      command = {action: 'create', scope: 'Groups', attribute: 'PrimaryGroupID'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def group_set_real_name(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:real_name]
      attribs[:value] = attribs[:value] || attribs[:long_name]
      attribs[:value] = attribs[:value] || attribs[:longname]
      attribs[:value] = attribs[:value] || attribs[:full_name]
      attribs[:value] = attribs[:value] || attribs[:fullname]
      attribs[:value] = attribs[:value] || attribs[:name]
      attribs[:value] = attribs[:value] || attribs[:group_name]
      attribs[:value] = attribs[:value] || attribs[:groupname]
      attribs[:value] = attribs[:value] || attribs[:gid]
      attribs[:value] = attribs[:value] || attribs[:cn]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :real_name )

      command = {action: 'create', scope: 'Groups', attribute: 'RealName'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # create group     -- dscl . -create /Groups/ladmins
    # add group passwd -- dscl . -create /Groups/ladmins passwd “*”
    # add group name   -- dscl . -create /Groups/ladmins RealName “Local Admins”
    # group ID number  -- dscl . -create /Groups/ladmins gid 400
    # group id number  -- dscl . -create /Groups/GROUP PrimaryGroupID GID
    def group_create_full(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      answer          = []
      attribs[:value] = nil
      answer         << group_create_min( attribs, dir_info )
      attribs[:value] = nil
      answer         << group_set_primary_group_id( attribs, dir_info )
      attribs[:value] = nil
      answer         << group_set_real_name( attribs, dir_info )
      # attribs[:value] = nil
      # answer         << group_set_password( attribs, dir_info )

      return answer
    end
    alias_method :group_create, :group_create_full

  end
end
