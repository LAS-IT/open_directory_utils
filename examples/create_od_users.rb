#!/usr/bin/env ruby -w

require 'yaml'
require 'open_directory_utils'

# setup server connection
srv_info = {}
begin
  srv_info = YAML.load_file( File.open('connection.yml') )
rescue Errno::ENOENT, LoadError, Psych::Error, Psych::SyntaxError
  srv_info = {srv_hostname: 'od.example.com', srv_username: 'odsshlogin',
              dir_username: 'diradmin', dir_password: 'T0p-S3cret' }
end

od = OpenDirectoryUtils::Connection.new( srv_info )
puts "\nSERVER SETTINGS:"
pp od


# get users
users = []
begin
  users  = YAML.load( File.open('users.yml') )
rescue Errno::ENOENT, LoadError, Psych::SyntaxError, YAML::Error
  users = [
    {username: 'odtest1', usernumber: '87654321', primary_group_id: 1031},
    {username: 'odtest2', usernumber: '87654322', primary_group_id: 1031},
  ]
ensure
  puts "\nUSERS:"
  pp users
end

make   = false
puts "Review the user data \nEnter 'Y' to create od accounts\n  (otherwise you see a dry run)"
answer = gets.chomp.downcase
if answer.eql? 'y'
  make_accts = true
end

# create accounts
puts "\nCreating OD Accounts:"
Array(users).each do |person|
  # show commands
  pp od.send(:user_create, person, od.dir_info)
  # Make Account
  pp od.run(command: :user_create, params: person )  if make_accts.eql? true
end
