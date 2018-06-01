require "open_directory_utils/dscl"
require "open_directory_utils/clean_check"

module OpenDirectoryUtils

  # http://krypted.com/mac-os-x/create-groups-using-dscl/
  # https://apple.stackexchange.com/questions/307173/creating-a-group-via-users-groups-in-command-line?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module CommandsGroup

    include OpenDirectoryUtils::Dscl
    include OpenDirectoryUtils::CleanCheck

    def group_shortname_alternatives(attribs)
      shortname = attribs[:shortname]
      shortname = shortname || attribs[:groupname]
      shortname = shortname || attribs[:gid]
      shortname = shortname || attribs[:cn]
      return shortname
    end

    # dscl . read /Groups/ladmins
    def group_get_info(attribs, dir_info)
      attribs[:shortname] = group_shortname_alternatives(attribs)

      command = {action: 'read', scope: 'Groups'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def group_exists?(attribs, dir_info)
      group_get_info(attribs, dir_info)
    end

    # add 1st user   -- dscl . create /Groups/ladmins GroupMembership localadmin
    # add more users -- dscl . append /Groups/ladmins GroupMembership 2ndlocaladmin
    def group_add_user(attribs, dir_info)
      attribs[:shortname] = group_shortname_alternatives(attribs)

      # value <- is username
      attribs[:value]     = attribs[:value]     || attribs[:username]
      attribs[:value]     = attribs[:value]     || attribs[:uid]

      # Will assume we are not adding the first user!
      command = { action: 'append', scope: 'Groups',
                  attribute: 'GroupMembership'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$SHORTNAME GroupMembership $VALUE
    # # dseditgroup -o edit -d $Username -t user $GroupName
    def group_remove_user(attribs, dir_info)
      attribs[:shortname] = group_shortname_alternatives(attribs)

      # value <- is username
      attribs[:value]     = attribs[:value]     || attribs[:username]
      attribs[:value]     = attribs[:value]     || attribs[:uid]

      command = { action: 'delete', scope: 'Groups',
                  attribute: 'GroupMembership'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # dscl . -delete /Groups/yourGroupName
    # https://tutorialforlinux.com/2011/09/15/delete-users-and-groups-from-terminal/
    def group_delete(attribs, dir_info)
      attribs[:shortname] = group_shortname_alternatives(attribs)

      command = {action: 'delete', scope: 'Groups'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # create group     -- dscl . -create /Groups/ladmins
    # add group passwd -- dscl . -create /Groups/ladmins passwd “*”
    # add group name   -- dscl . -create /Groups/ladmins RealName “Local Admins”
    # group ID number  -- dscl . -create /Groups/ladmins gid 400
    # group id number  -- dscl . -create /Groups/GROUP PrimaryGroupID GID
    def group_create(attribs, dir_info)
      attribs[:shortname] = group_shortname_alternatives(attribs)

      answer     = []
      create     = { action: 'create', scope: 'Groups'}
      user_attrs = attribs.merge(create)
      answer    << dscl( user_attrs, dir_info )

      create     = {action: 'create', scope: 'Groups',
                    attribute: 'passwd', value: '*'}
      user_attrs = attribs.merge(create)
      answer    << dscl( user_attrs, dir_info )

      create     = {action: 'create', scope: 'Groups',
                    attribute: 'RealName', value: 'Some Group'}
      user_attrs = attribs.merge(create)
      answer    << dscl( user_attrs, dir_info )

      create     = {action: 'create', scope: 'Groups',
                    attribute: 'PrimaryGroupID', value: '1032'}
      user_attrs = attribs.merge(create)
      answer    << dscl( user_attrs, dir_info )

      return answer
    end

  end
end
