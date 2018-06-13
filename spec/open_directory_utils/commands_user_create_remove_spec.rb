require 'spec_helper'
require "open_directory_utils/commands_user_create_remove"

RSpec.describe OpenDirectoryUtils::CommandsUserCreateRemove do

  context "build commands" do

    let(:user)     { Object.new.extend(OpenDirectoryUtils::CommandsUserCreateRemove) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy',
                      dsedit: '/usr/sbin/dseditgroup'} }

    describe "user_get_info" do
      it "with record_name" do
        attribs = {record_name: 'someone'}
        expect { user.send(:user_get_info, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with recordname" do
        attribs = {recordname: 'someone'}
        expect { user.send(:user_get_info, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with user_name" do
        attribs = {user_name: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with username" do
        attribs = {username: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with short_name" do
        attribs = {short_name: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with shortname" do
        attribs = {shortname: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with uid" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra value" do
        attribs = {uid: 'someone', value: 'nothing'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra attribute" do
        attribs = {uid: 'someone', attribute: 'nothing'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_get_info" do
      it "user_exists? - user_name" do
        attribs = {user_name: 'someone'}
        answer  = user.send(:user_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_real_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with real_name" do
        attribs = {username: 'someone', real_name: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with realname" do
        attribs = {uid: 'someone', realname: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with first and lastname" do
        attribs = {uid: 'someone', first_name: "John", last_name: "DOE"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John DOE"'
        expect( answer ).to eq( correct )
      end
      it "with cn" do
        attribs = {uid: 'someone', cn: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_first_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "John"}
        answer  = user.send(:user_set_first_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "John"'
        expect( answer ).to eq( correct )
      end
      it "with real_name" do
        attribs = {username: 'someone', first_name: "John"}
        answer  = user.send(:user_set_first_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "John"'
        expect( answer ).to eq( correct )
      end
      it "with realname" do
        attribs = {uid: 'someone', given_name: "John"}
        answer  = user.send(:user_set_first_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "John"'
        expect( answer ).to eq( correct )
      end
      it "without first name" do
        attribs = {uid: 'someone', last_name: "DOE"}
        expect { user.send(:user_set_first_name, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :first_name/)
      end
    end

    describe "user_set_last_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "Doe"}
        answer  = user.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with last_name" do
        attribs = {username: 'someone', last_name: "Doe"}
        answer  = user.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with surname" do
        attribs = {uid: 'someone', surname: "Doe"}
        answer  = user.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with sn" do
        attribs = {uid: 'someone', sn: "Doe"}
        answer  = user.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "without last name - with uid" do
        attribs = {uid: 'someone', first_name: "DOE"}
        answer  = user.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"'
        expect( answer ).to eq( correct )
      end
      it "without last name - with realname" do
        attribs = {uid: 'someone', real_name: "John DOE"}
        answer  = user.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "John DOE"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_unique_id" do
      it "with uniqueid" do
        attribs = {user_name: 'someone', uniqueid: 987654}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with unique_id" do
        attribs = {username: 'someone', unique_id: 987654}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with uidnumber" do
        attribs = {uid: 'someone', uidnumber: "987654"}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with value" do
        attribs = {uid: 'someone', value: "987654"}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_primary_group_id" do
      it "using primary_group_id" do
        attribs = {uid: 'someone', primary_group_id: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using group_id" do
        attribs = {uid: 'someone', group_id: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using gidnumber" do
        attribs = {uid: 'someone', gidnumber: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_od_set_nfs_home_directory" do
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', nfs_home_directory: "/home/someone"}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', home_directory: "/home/someone"}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: "/home/someone"}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using blank" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_password" do
      it "using password" do
        attribs = {uid: 'someone', password: 'A-Big-Secret'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using passwd" do
        attribs = {uid: 'someone', passwd: 'A-Big-Secret'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 'A-Big-Secret'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using no value" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"'
        expect( answer ).to eq( correct )
      end
    end
    describe "user_password_verified?" do
      it "using password" do
        attribs = {uid: 'someone', password: 'A-Big-Secret'}
        answer  = user.send(:user_password_verified?, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1 -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using passwd" do
        attribs = {uid: 'someone', passwd: 'A-Big-Secret'}
        answer  = user.send(:user_password_verified?, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1 -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 'A-Big-Secret'}
        answer  = user.send(:user_password_verified?, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1 -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
    end

    describe "prebuild commands - enable / disable user" do
      it "user_enable_login" do
        attribs = {username: 'someone'}
        answer  = user.send(:user_enable_login, attribs, srv_info)
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {username: 'someone'}
        answer  = user.send(:user_disable_login, attribs, srv_info)
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser'
        expect( answer ).to eq( correct )
      end
    end

    define "user_set_shell" do
      it "with default" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"'
        expect( answer ).to eq( correct )
      end
      it "with shell" do
        attribs = {uid: 'someone', shell: '/bin/zsh'}
        answer  = user.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
      it "with user_shell" do
        attribs = {uid: 'someone', user_shell: '/bin/zsh'}
        answer  = user.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_email" do
      it "user_set_email with 'apple-user-mailattribute'" do
        attribs = {uid: 'someone', 'apple-user-mailattribute' => 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with apple_user_mailattribute" do
        attribs = {uid: 'someone', apple_user_mailattribute: 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with apple_user_mailattribute" do
        attribs = {uid: 'someone', email: 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with mail" do
        attribs = {uid: 'someone', mail: 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
    end

    describe "user_delete" do
      it "with uid" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with username" do
        attribs = {username: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with shortname" do
        attribs = {user_name: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra attribute" do
        attribs = {user_name: 'someone', attribute: 'nothing'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra value" do
        attribs = {user_name: 'someone', value: 'nothing'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_create_min" do
      let(:correct) {
        [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "12345"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "9876"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
      }
      it "with needed uid" do
        attribs = { uid: 'someone', uidnumber: '12345', gidnumber: '9876' }
        answer  = user.send(:user_create_min, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with needed username" do
        attribs = { username: 'someone', uidnumber: '12345', gidnumber: '9876'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with needed shortname" do
        attribs = { user_name: 'someone', uidnumber: '12345', gidnumber: '9876'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with all enable: true" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: true}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all enable: true" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: 'true'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all enable: false" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: false}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all enable: 'junk'" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: 'junk'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all realname" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with first & last name" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'Special', uniqueid: '9876543'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with extra attributes - no uid" do
        attribs = { email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        expect { user.send(:user_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with missing shortname" do
        attribs = { }
        expect { user.send(:user_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
    end

    describe "user_add_to_group" do
      it "with user_name & group_membership" do
        attribs = {user_name: 'someone', group_membership: 'student'}
        answer  = user.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with user_name & group_name" do
        attribs = {user_name: 'someone', group_name: 'student'}
        answer  = user.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with username & groupname" do
        attribs = {username: 'someone', groupname: 'student'}
        answer  = user.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with uid & gid" do
        attribs = {uid: 'someone', gid: 'student'}
        answer  = user.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_remove_from_group" do
      it "with user_name & group_membership" do
        attribs = {user_name: 'someone', group_membership: 'student'}
        answer  = user.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with user_name & group_name" do
        attribs = {user_name: 'someone', group_name: 'student'}
        answer  = user.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with username & groupname" do
        attribs = {username: 'someone', groupname: 'student'}
        answer  = user.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with uid & gid" do
        attribs = {uid: 'someone', gid: 'student'}
        answer  = user.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_create" do
      let(:correct) {[
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone SPECIAL"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
        '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
      ]}
      it "with minimal attributes" do
        attribs = { uid: 'someone', gidnumber: '1032', uniqueid: '9876543' }
        answer  = user.send(:user_create, attribs, srv_info)
        min_correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( min_correct )
      end
      it "with real_name attributes" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: "SPECIAL", uniqueid: '9876543',
                    real_name: 'Someone SPECIAL' }
        answer  = user.send(:user_create, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with first & last name attributes" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        answer  = user.send(:user_create, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with group_membership & password attributes" do
        attribs  = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543',
                    group_membership: 'testgrp', password: 'TopSecret', enable: true
                  }
        answer   = user.send(:user_create, attribs, srv_info)
        with_all = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "TopSecret"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"',
          '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user testgrp',
        ]
        expect( answer ).to eq( with_all )
      end
      it "without email" do
        attribs  = {uid: 'someone', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        answer   = user.send(:user_create, attribs, srv_info)
        no_email = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
        ]
        expect(answer).to eq( no_email )
      end
      it "with missing attributes (no firstname)" do
        attribs  = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    last_name: 'SPECIAL', uniqueid: '9876543'}
        answer   = user.send(:user_create, attribs, srv_info)
        no_first = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect(answer).to eq( no_first )
      end
      it "with missing attributes (no lastname)" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', uniqueid: '9876543', password: 'TopSecret'}
        answer  = user.send(:user_create, attribs, srv_info)
        no_last = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "TopSecret"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect(answer).to eq( no_last )
      end
      it "with missing attributes (no username)" do
        attribs = { email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        expect { user.send(:user_create, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with missing attributes (no PrimaryGroupID)" do
        attribs = { uid: 'someone', email: 'user@example.com',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        expect { user.send(:user_create, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :group_id/)
      end
      it "with missing attributes (no uniqueid)" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL'}
        expect { user.send(:user_create, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :unique_id/)
      end
    end

  end
end
