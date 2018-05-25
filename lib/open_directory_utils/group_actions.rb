module OpenDirectoryUtils
  
  # http://krypted.com/mac-os-x/create-groups-using-dscl/
  # https://apple.stackexchange.com/questions/307173/creating-a-group-via-users-groups-in-command-line?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  module GroupActions

    # dscl . read /Groups/ladmins
    def group_get_info
    end

    def group_exists?
    end

    # create group     -- dscl . -create /Groups/ladmins
    # add group passwd -- dscl . -create /Groups/ladmins passwd “*”
    # add group name   -- dscl . -create /Groups/ladmins RealName “Local Admins”
    # group ID number  -- dscl . -create /Groups/ladmins gid 400
    # group id number  -- dscl . -create /Groups/GROUP PrimaryGroupID GID
    def group_create
    end

    # dscl . -delete /Groups/yourGroupName
    # https://tutorialforlinux.com/2011/09/15/delete-users-and-groups-from-terminal/
    def group_delete
    end

    # add 1st user   -- dscl . create /Groups/ladmins GroupMembership localadmin
    # add more users -- dscl . append /Groups/ladmins GroupMembership 2ndlocaladmin
    def group_add_user
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$VALUE GroupMembership $UID_USERNAME
    # dseditgroup -o edit -d $Username -t user $GroupName
    def group_remove_user
    end

  end
end
