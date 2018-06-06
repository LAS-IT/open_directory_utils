# OpenDirectoryUtils

This Gem allows one to build or send pre-built commands to control
(common OD and LDAP attributes) on an OpenDirectory server.

One can also build custom DSCL commands and send them to the server as needed too.

## Change Log

* **v0.1.0** - 2018-06-06
  - can adjust and delete OD attributes for users and groups (pre-built ldap attributes comming soon)
* **v0.1.1** - 2018-06-06
  - refactored to separate OD attribute from LDAP attribute commands (shortened methods and better organization and shorter tests)

## ToDo

* Do not return dir admin password with command on errors
* test user_set_group_memebership
* test full creation again
* fix group cn tests
* LDAP attributes
* ADD EXAMPLE CODE
* Verify setting Password
* Verify testing Password
* Refactor Process Results
* Test dscl direct commands
* Check Connection Unit Tests
* Learn dscl property names from LDAP
* Lock and unlock account authentication
* verify which email address is LDAP (& seen in GUI)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open_directory_utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_directory_utils

## Usage

```ruby
require 'open_directory_utils'

# Usually Instantiate using ENV-VARS -
# srv_host_name: ENV['OD_HOSTNAME'],
# srv_user_name: ENV['OD_USERNAME'],
# dir_user_name: ENV['DIR_ADMIN_USER'],
# dir_password: ENV['DIR_ADMIN_PASS'],

# Instantiating using params
od = OpenDirectoryUtils.new(
        { srv_host_name: 'od_hostname', srv_user_name: 'od_ssh_username',
          dir_user_name: 'directory_admin_username',
          dir_password: 'directory_admin_password'
        }
      )

user_params = { user_name: 'someone', user_number: 9876, group_number: 4321,
                first_name: 'Someone', last__name: 'Special',
              }
group_params = {group_name: 'agroup', long_name: 'A Group', group_number: 5432}

# create a user
od.run( command: :user_create_full,  params: user_params )

# update user's record (all dscl and ldap fields are available)
od.run( command: :user_set_first_email,
        params: {user_name: 'someone', email: 'someone@example.com'} )
# add a second email address
od.run( command: :user_append_email,
        params: {user_name: 'someone', email: 'second@example.com'} )
# fix spelling of first name
od.run( command: :user_set_first_name,
        params: {user_name: 'someone', first_name: 'John'} )

# get user's record
od.run( command: :user_info,  params: user_params )

# create a group
od.run( command: :group_create_full, params: group_params )

# add the first user to the group
od.run( command: :group_add_first_user,
        params: {user_name: 'someone', group_name: 'agroup'} )
# add additional user to the group
od.run( command: :user_append_to_group,
        params: {user_name: 'existinguser', group_name: 'agroup'} )

# get group record and members inf
od.run( command: :group_info,  params: user_params )

# remove a user from a group
od.run( command: :user_remove_from_group,
        params: {user_name: 'someone', group_name: 'agroup'})
od.run( command: :user_remove_from_group,
        params: {user_name: 'existinguser', group_name: 'agroup'})

# delete a group
od.run( command: :group_delete, params: {group__name: 'agroup'})

# delete a user

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/open_directory_utils. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OpenDirectoryUtils project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/open_directory_utils/blob/master/CODE_OF_CONDUCT.md).
