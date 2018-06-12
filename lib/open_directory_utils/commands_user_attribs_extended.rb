# require "open_directory_utils/dscl"
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

    def user_set_city(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:locale]
      attribs[:value] = attribs[:value] || attribs[:city]
      attribs[:value] = attribs[:value] || attribs[:town]
      attribs[:value] = attribs[:value] || attribs[:l]

      check_critical_attribute( attribs, :value, :city )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'City'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    def user_create_chat(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:im_handle]
      attribs[:value] = attribs[:value] || attribs[:imhandle]
      attribs[:value] = attribs[:value] || attribs[:handle]
      attribs[:value] = attribs[:value] || attribs[:chat]
      attribs[:value] = attribs[:value] || attribs[:im]

      check_critical_attribute( attribs, :value, :chat )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'IMHandle'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    def user_append_chat(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:im_handle]
      attribs[:value] = attribs[:value] || attribs[:imhandle]
      attribs[:value] = attribs[:value] || attribs[:handle]
      attribs[:value] = attribs[:value] || attribs[:chat]
      attribs[:value] = attribs[:value] || attribs[:im]

      check_critical_attribute( attribs, :value, :chat )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'append', scope: 'Users', attribute: 'IMHandle'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # first  - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "$VALUE"
    # others - /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "$VALUE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$USER apple-imhandle "AIM:created: $CREATE"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "ICQ:start: $START"
    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$USER apple-imhandle "MSN:end: $END"
    def user_set_chat(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:values] = attribs[:values] || attribs[:im_handle]
      attribs[:values] = attribs[:values] || attribs[:imhandle]
      attribs[:values] = attribs[:values] || attribs[:handle]
      attribs[:values] = attribs[:values] || attribs[:chat]
      attribs[:values] = attribs[:values] || attribs[:im]

      answer = []
      Array(attribs[:values]).each_with_index do |value, index|
        attribs[:value] = value
        case index
        when 0
          answer << user_create_chat(attribs, dir_info)
        else
          answer << user_append_chat(attribs, dir_info)
        end
      end

      answer
    end
    alias_method :user_set_im_handle, :user_set_chat
    alias_method :user_set_chat_channels, :user_set_chat
    # alias_method :las_created_date, :user_set_chat
    # alias_method :las_start_date, :user_set_chat
    # alias_method :las_end_date, :user_set_chat


    def user_set_comment(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:description]
      attribs[:value] = attribs[:value] || attribs[:comment]

      check_critical_attribute( attribs, :value, :comment )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Comment'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_description, :user_set_comment

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-company "$VALUE"
    def user_set_company(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:company]

      check_critical_attribute( attribs, :value, :company )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Company'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    # alias_method :las_program_info, :user_set_company

    def user_set_country(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:country]
      attribs[:value] = attribs[:value] || attribs[:c]

      check_critical_attribute( attribs, :value, :country )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Country'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_department(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:department_number]
      attribs[:value] = attribs[:value] || attribs[:departmentnumber]
      attribs[:value] = attribs[:value] || attribs[:dept_number]
      attribs[:value] = attribs[:value] || attribs[:deptnumber]
      attribs[:value] = attribs[:value] || attribs[:department]
      attribs[:value] = attribs[:value] || attribs[:dept]

      check_critical_attribute( attribs, :value, :department )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Departmemt'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_job_title(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:job_title]
      attribs[:value] = attribs[:value] || attribs[:jobtitle]
      attribs[:value] = attribs[:value] || attribs[:title]

      check_critical_attribute( attribs, :value, :job_title )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'JobTitle'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_title, :user_set_job_title

    # 1st keyword    -- /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-keyword "$VALUE"
    # other keywords --  /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_create_keyword(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:keywords]
      attribs[:value] = attribs[:value] || attribs[:keyword]

      check_critical_attribute( attribs, :value, :keyword )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Keywords'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_create_keywords, :user_create_keyword

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_append_keyword(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:keywords]
      attribs[:value] = attribs[:value] || attribs[:keyword]

      check_critical_attribute( attribs, :value, :keyword )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'append', scope: 'Users', attribute: 'Keywords'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_append_keywords, :user_append_keyword

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_keywords(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:values] = attribs[:values] || attribs[:keywords]
      attribs[:values] = attribs[:values] || attribs[:keyword]

      answer = []
      Array(attribs[:values]).each_with_index do |value, index|
        attribs[:value] = value

        case index
        when 0
          answer << user_create_keyword(attribs, dir_info)
        else
          answer << user_append_keyword(attribs, dir_info)
        end
      end

      answer
    end
    alias_method :user_set_keyword, :user_set_keywords

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_home_phone(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:home_phone_number]
      attribs[:value] = attribs[:value] || attribs[:home_number]
      attribs[:value] = attribs[:value] || attribs[:home_phone]

      check_critical_attribute( attribs, :value, :home_phone )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'HomePhoneNumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_mobile_phone(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:mobile_phone_number]
      attribs[:value] = attribs[:value] || attribs[:mobile_number]
      attribs[:value] = attribs[:value] || attribs[:mobile_phone]

      check_critical_attribute( attribs, :value, :mobile_phone )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'MobileNumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_mobile_number, :user_set_mobile_phone
    alias_method :user_set_mobile_phone_number, :user_set_mobile_phone

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_work_phone(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:work_phone_number]
      attribs[:value] = attribs[:value] || attribs[:phone_number]
      attribs[:value] = attribs[:value] || attribs[:work_number]
      attribs[:value] = attribs[:value] || attribs[:work_phone]
      attribs[:value] = attribs[:value] || attribs[:number]
      attribs[:value] = attribs[:value] || attribs[:phone]

      check_critical_attribute( attribs, :value, :work_phone )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'PhoneNumber'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -append /Users/$shortname_USERNAME apple-keyword "$VALUE"
    def user_set_name_suffix(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:name_suffix]
      attribs[:value] = attribs[:value] || attribs[:suffix]
      check_critical_attribute( attribs, :value, :name_suffix )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'NameSuffix'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_organization_info(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:organization_info]
      attribs[:value] = attribs[:value] || attribs[:organization]
      attribs[:value] = attribs[:value] || attribs[:org_info]
      attribs[:value] = attribs[:value] || attribs[:org]
      check_critical_attribute( attribs, :value, :organization_info )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'OrganizationInfo'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_org_info, :user_set_organization_info
    # alias_method :user_set_student_id, :user_set_organization_info

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-webloguri "$VALUE"
    def user_set_postal_code(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:postal_code]
      attribs[:value] = attribs[:value] || attribs[:post_code]
      attribs[:value] = attribs[:value] || attribs[:zip_code]
      attribs[:value] = attribs[:value] || attribs[:zip]
      check_critical_attribute( attribs, :value, :postal_code )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'PostalCode'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_post_code, :user_set_postal_code
    alias_method :user_set_zip_code, :user_set_postal_code
    # alias_method :las_sync_date, :user_set_weblog

    def user_set_relationships(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:relationships]
      attribs[:value] = attribs[:value] || attribs[:relations]
      check_critical_attribute( attribs, :value, :relationships )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Relationships'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_state(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:state]
      check_critical_attribute( attribs, :value, :state )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'State'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end

    def user_set_street(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:address]
      attribs[:value] = attribs[:value] || attribs[:street]
      check_critical_attribute( attribs, :value, :street )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Street'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_address, :user_set_street

    # /usr/bin/dscl -u diradmin -P A-B1g-S3cret /LDAPv3/127.0.0.1 -create /Users/$shortname_USERNAME apple-webloguri "$VALUE"
    def user_set_weblog(attribs, dir_info)
      attribs = user_record_name_alternatives(attribs)
      check_critical_attribute( attribs, :record_name )

      attribs[:value] = attribs[:value] || attribs[:weblog]
      attribs[:value] = attribs[:value] || attribs[:blog]
      check_critical_attribute( attribs, :value, :weblog )
      attribs    = tidy_attribs(attribs)

      command    = {action: 'create', scope: 'Users', attribute: 'Weblog'}
      user_attrs = attribs.merge(command)

      dscl( user_attrs, dir_info )
    end
    alias_method :user_set_blog, :user_set_weblog
    # alias_method :las_sync_date, :user_set_weblog

  end
end
