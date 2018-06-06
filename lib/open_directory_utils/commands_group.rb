require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"

module OpenDirectoryUtils

  # this is a long list of pre-built dscl commands affecting groups to accomplish common actions
  # @note - these commands were derived from the following resrouces:
  # * http://krypted.com/mac-os-x/create-groups-using-dscl/
  # * https://apple.stackexchange.com/questions/307173/creating-a-group-via-users-groups-in-command-line?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsGroup

    include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck

    def group_record_name_alternatives(attribs)
      attribs[:record_name] = nil
      attribs[:record_name] = attribs[:group_name]
      attribs[:record_name] = attribs[:record_name] || attribs[:groupname]
      attribs[:record_name] = attribs[:record_name] || attribs[:gid]
      attribs[:record_name] = attribs[:record_name] || attribs[:cn]
      return attribs
    end

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

    # add 1st user   -- dscl . -read /Groups/ladmins
    def user_in_group?(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)
      # attribs[:record_name] = attribs[:record_name] || attribs[:group_name]
      # attribs[:record_name] = attribs[:record_name] || attribs[:groupname]
      # attribs[:record_name] = attribs[:record_name] || attribs[:gid]

      check_critical_attribute( attribs, :record_name, :groupname )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'read', scope: 'Groups', attribute: nil, value: nil}
      user_attrs  = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # http://krypted.com/mac-os-x/create-groups-using-dscl/
    # https://superuser.com/questions/214004/how-to-add-user-to-a-group-from-mac-os-x-command-line?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    # sudo dseditgroup -o edit -a $username_to_add -t user admin
    # sudo dseditgroup -o edit -a $username_to_add -t user wheel
    # http://osxdaily.com/2007/10/29/how-to-add-a-user-from-the-os-x-command-line-works-with-leopard/
    #
    # add 1st user   -- dscl . -create /Groups/ladmins GroupMembership localadmin
    # add more users -- dscl . -append /Groups/ladmins GroupMembership 2ndlocaladmin
    def user_first_in_group(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)
      # attribs[:record_name] = attribs[:record_name] || attribs[:group_name]
      # attribs[:record_name] = attribs[:record_name] || attribs[:groupname]
      # attribs[:record_name] = attribs[:record_name] || attribs[:gid]

      attribs[:value]       = attribs[:value]       || attribs[:user_name]
      attribs[:value]       = attribs[:value]       || attribs[:username]
      attribs[:value]       = attribs[:value]       || attribs[:uid]

      check_critical_attribute( attribs, :record_name, :groupname )
      check_critical_attribute( attribs, :value, :username )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Groups', attribute: 'GroupMembership'}
      user_attrs  = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    def user_append_to_group(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)
      # attribs[:record_name] = attribs[:record_name] || attribs[:group_name]
      # attribs[:record_name] = attribs[:record_name] || attribs[:groupname]
      # attribs[:record_name] = attribs[:record_name] || attribs[:gid]

      attribs[:value]       = attribs[:value]       || attribs[:user_name]
      attribs[:value]       = attribs[:value]       || attribs[:username]
      attribs[:value]       = attribs[:value]       || attribs[:uid]

      check_critical_attribute( attribs, :record_name, :groupname )
      check_critical_attribute( attribs, :value, :username )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'append', scope: 'Groups', attribute: 'GroupMembership'}
      user_attrs  = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_add_to_group, :user_append_to_group

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$VALUE GroupMembership $shortname_USERNAME
    def user_remove_from_group(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)
      # attribs[:record_name] = attribs[:record_name] || attribs[:group_name]
      # attribs[:record_name] = attribs[:record_name] || attribs[:groupname]
      # attribs[:record_name] = attribs[:record_name] || attribs[:gid]

      attribs[:value]       = attribs[:value]       || attribs[:user_name]
      attribs[:value]       = attribs[:value]       || attribs[:username]
      attribs[:value]       = attribs[:value]       || attribs[:uid]

      check_critical_attribute( attribs, :record_name, :groupname )
      check_critical_attribute( attribs, :value, :username )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'delete', scope: 'Groups', attribute: 'GroupMembership'}
      user_attrs  = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # add 1st user   -- dscl . create /Groups/ladmins GroupMembership localadmin
    # add more users -- dscl . append /Groups/ladmins GroupMembership 2ndlocaladmin
    def group_add_first_user(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      # value = username
      attribs[:value]     = attribs[:value] || attribs[:user_name]
      attribs[:value]     = attribs[:value] || attribs[:username]
      attribs[:value]     = attribs[:value] || attribs[:uid]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :username )

      # Will assume we are not adding the first user!
      command = { action: 'create', scope: 'Groups',
                  attribute: 'GroupMembership'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def group_has_user?(attribs, dir_info)
      group_get_info(attribs, dir_info)
    end

    # add 1st user   -- dscl . create /Groups/ladmins GroupMembership localadmin
    # add more users -- dscl . append /Groups/ladmins GroupMembership 2ndlocaladmin
    def group_add_user(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      # value = username
      attribs[:value]     = attribs[:value] || attribs[:user_name]
      attribs[:value]     = attribs[:value] || attribs[:username]
      attribs[:value]     = attribs[:value] || attribs[:uid]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :username )

      # Will assume we are not adding the first user!
      command = { action: 'append', scope: 'Groups',
                  attribute: 'GroupMembership'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$SHORTNAME GroupMembership $VALUE
    # # dseditgroup -o edit -d $Username -t user $GroupName
    def group_remove_user(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      # value <- is username
      attribs[:value]     = attribs[:value] || attribs[:user_name]
      attribs[:value]     = attribs[:value] || attribs[:username]
      attribs[:value]     = attribs[:value] || attribs[:uid]

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :username )

      command = { action: 'delete', scope: 'Groups',
                  attribute: 'GroupMembership'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
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

    # probably can't create password for group?
    # /usr/bin/dscl -u diradmin -P liaP-meD-Aj-pHi-hOb-en-c /LDAPv3/127.0.0.1/ -create /Groups/odgrouptest passwd "*"
    #  "<main> attribute status: eDSNoStdMappingAvailable\n" +
    #  "<dscl_cmd> DS Error: -14140 (eDSNoStdMappingAvailable)"]
    def group_set_passwd(attribs, dir_info)
      attribs = group_record_name_alternatives(attribs)

      attribs[:value] = attribs[:value] || attribs[:password]
      attribs[:value] = attribs[:value] || attribs[:passwd]
      attribs[:value] = attribs[:value] || '*'

      check_critical_attribute( attribs, :record_name )
      check_critical_attribute( attribs, :value, :password )

      command = {action: 'passwd', scope: 'Groups', attribute: nil}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :group_set_password, :group_set_passwd

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
