module OpenDirectoryUtils
  module GroupCommands

    def group_get_info
    end

    def group_exists?
    end

    def group_create
    end

    def group_delete
    end

    def group_add_user
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1/ -delete /Groups/$VALUE GroupMembership $UID_USERNAME
    def group_remove_user
    end

  end
end
