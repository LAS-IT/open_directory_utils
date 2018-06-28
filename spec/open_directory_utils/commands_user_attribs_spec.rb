require 'spec_helper'
require "open_directory_utils/commands_user_attribs"

RSpec.describe OpenDirectoryUtils::CommandsUserAttribs do

  context "build commands for syncing extended user attributes" do

    let(:ext_od)   { Object.new.extend(OpenDirectoryUtils::CommandsUserAttribs) }
    let(:attribs)  { {username: 'someone', email: 'user@example.com',
                      first_name: 'Someone', last_name: "SPECIAL",
                      real_name: 'Someone (Very) SPECIAL', unique_id: '9876543',
                      group_number: '1032', group_name: 'test', city: 'Leysin',
                      chat: 'AIM:someone', comment: 'Hi There', company: 'LAS',
                      country: 'CH', department: 'IT', job_title: 'DevOps',
                      keyword: 'employee', home_phone: "024 654 1234",
                      mobile_phone: '079 678 4321', work_phone: 'x4890',
                      name_suffix: 'Jr', org_info: 'Top', postal_code: '1234',
                      relationships: 'John', state: 'Vaud',
                      street: 'chemin de la Source',
                      weblog: 'http://example.ch/weblog',
                    } }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy',
                      dsedit: '/usr/sbin/dseditgroup'} }

    describe "user_get_info" do
      it "with record_name" do
        attribs = {record_name: 'someone'}
        expect { ext_od.send(:user_get_info, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with recordname" do
        attribs = {recordname: 'someone'}
        expect { ext_od.send(:user_get_info, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with user_name" do
        attribs = {user_name: 'someone'}
        answer  = ext_od.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with username" do
        attribs = {username: 'someone'}
        answer  = ext_od.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with short_name" do
        attribs = {short_name: 'someone'}
        answer  = ext_od.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with shortname" do
        attribs = {shortname: 'someone'}
        answer  = ext_od.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with uid" do
        attribs = {uid: 'someone'}
        answer  = ext_od.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra value" do
        attribs = {uid: 'someone', value: 'nothing'}
        answer  = ext_od.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra attribute" do
        attribs = {uid: 'someone', attribute: 'nothing'}
        answer  = ext_od.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_get_info" do
      it "user_exists? - user_name" do
        attribs = {user_name: 'someone'}
        answer  = ext_od.send(:user_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_real_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "John Doe"}
        answer  = ext_od.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with real_name" do
        attribs = {username: 'someone', real_name: "John Doe"}
        answer  = ext_od.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with realname" do
        attribs = {uid: 'someone', realname: "John Doe"}
        answer  = ext_od.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with first and lastname" do
        attribs = {uid: 'someone', first_name: "John", last_name: "DOE"}
        answer  = ext_od.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John DOE"'
        expect( answer ).to eq( correct )
      end
      it "with cn" do
        attribs = {uid: 'someone', cn: "John Doe"}
        answer  = ext_od.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_first_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "John"}
        answer  = ext_od.send(:user_set_first_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "John"'
        expect( answer ).to eq( correct )
      end
      it "with real_name" do
        attribs = {username: 'someone', first_name: "John"}
        answer  = ext_od.send(:user_set_first_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "John"'
        expect( answer ).to eq( correct )
      end
      it "with realname" do
        attribs = {uid: 'someone', given_name: "John"}
        answer  = ext_od.send(:user_set_first_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "John"'
        expect( answer ).to eq( correct )
      end
      it "without first name" do
        attribs = {uid: 'someone', last_name: "DOE"}
        expect { ext_od.send(:user_set_first_name, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :first_name/)
      end
    end

    describe "user_set_last_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "Doe"}
        answer  = ext_od.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with last_name" do
        attribs = {username: 'someone', last_name: "Doe"}
        answer  = ext_od.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with surname" do
        attribs = {uid: 'someone', surname: "Doe"}
        answer  = ext_od.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with sn" do
        attribs = {uid: 'someone', sn: "Doe"}
        answer  = ext_od.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Doe"'
        expect( answer ).to eq( correct )
      end
      it "without last name - with uid" do
        attribs = {uid: 'someone', first_name: "DOE"}
        answer  = ext_od.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"'
        expect( answer ).to eq( correct )
      end
      it "without last name - with realname" do
        attribs = {uid: 'someone', real_name: "John DOE"}
        answer  = ext_od.send(:user_set_last_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "John DOE"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_unique_id" do
      it "with uniqueid" do
        attribs = {user_name: 'someone', uniqueid: 987654}
        answer  = ext_od.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with unique_id" do
        attribs = {username: 'someone', unique_id: 987654}
        answer  = ext_od.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with uidnumber" do
        attribs = {uid: 'someone', uidnumber: "987654"}
        answer  = ext_od.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with value" do
        attribs = {uid: 'someone', value: "987654"}
        answer  = ext_od.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_primary_group_id" do
      it "using primary_group_id" do
        attribs = {uid: 'someone', primary_group_id: 1043}
        answer  = ext_od.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using group_id" do
        attribs = {uid: 'someone', group_id: 1043}
        answer  = ext_od.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using gidnumber" do
        attribs = {uid: 'someone', gidnumber: 1043}
        answer  = ext_od.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 1043}
        answer  = ext_od.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_od_set_nfs_home_directory" do
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', nfs_home_directory: "/home/someone"}
        answer  = ext_od.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', home_directory: "/home/someone"}
        answer  = ext_od.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: "/home/someone"}
        answer  = ext_od.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using blank" do
        attribs = {uid: 'someone'}
        answer  = ext_od.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_password" do
      it "using password" do
        attribs = {uid: 'someone', password: 'A-Big-Secret'}
        answer  = ext_od.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using passwd" do
        attribs = {uid: 'someone', passwd: 'A-Big-Secret'}
        answer  = ext_od.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 'A-Big-Secret'}
        answer  = ext_od.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using no value" do
        attribs = {uid: 'someone'}
        answer  = ext_od.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"'
        expect( answer ).to eq( correct )
      end
    end
    describe "user_password_verified?" do
      it "using password" do
        attribs = {uid: 'someone', password: 'A-Big-Secret'}
        answer  = ext_od.send(:user_password_verified?, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1 -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using passwd" do
        attribs = {uid: 'someone', passwd: 'A-Big-Secret'}
        answer  = ext_od.send(:user_password_verified?, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1 -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 'A-Big-Secret'}
        answer  = ext_od.send(:user_password_verified?, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1 -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
    end

    describe "prebuild commands - enable / disable user" do
      it "user_enable_login" do
        attribs = {username: 'someone'}
        answer  = ext_od.send(:user_enable_login, attribs, srv_info)
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {username: 'someone'}
        answer  = ext_od.send(:user_disable_login, attribs, srv_info)
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser'
        expect( answer ).to eq( correct )
      end
    end

    define "user_set_shell" do
      it "with default" do
        attribs = {uid: 'someone'}
        answer  = ext_od.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"'
        expect( answer ).to eq( correct )
      end
      it "with shell" do
        attribs = {uid: 'someone', shell: '/bin/zsh'}
        answer  = ext_od.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
      it "with user_shell" do
        attribs = {uid: 'someone', user_shell: '/bin/zsh'}
        answer  = ext_od.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_email" do
      it "user_set_email with 'apple-user-mailattribute'" do
        attribs = {uid: 'someone', 'apple-user-mailattribute' => 'user@example.com'}
        answer  = ext_od.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with apple_user_mailattribute" do
        attribs = {uid: 'someone', apple_user_mailattribute: 'user@example.com'}
        answer  = ext_od.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with apple_user_mailattribute" do
        attribs = {uid: 'someone', email: 'user@example.com'}
        answer  = ext_od.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with mail" do
        attribs = {uid: 'someone', mail: 'user@example.com'}
        answer  = ext_od.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
    end

    describe "Set city attribute" do
      it "city - with city" do
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Leysin"'
        expect( answer ).to eq( correct )
      end
      it "city - with town" do
        attribs[:city] = nil
        attribs[:town] = "Aigle"
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Aigle"'
        expect( answer ).to eq( correct )
      end
      it "city - with locale" do
        attribs[:city] = nil
        attribs[:locale] = "Aigle"
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Aigle"'
        expect( answer ).to eq( correct )
      end
      it "city - with l" do
        attribs[:city] = nil
        attribs[:l] = "Aigle"
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Aigle"'
        expect( answer ).to eq( correct )
      end
      it "witout city" do
        attribs[:city] = nil
        attribs[:town] = nil
        expect { ext_od.send(:user_set_city, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :city/)
      end
      it "with empty city" do
        attribs[:city] = ""
        attribs[:town] = nil
        expect { ext_od.send(:user_set_city, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :city/)
      end
    end

    describe "Set Chat values" do
      it "set 1st chat" do
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "AIM:someone"'
        expect( answer ).to eq( correct )
      end
      it "set 1st chat as im_handle" do
        attribs[:chat] = nil
        attribs[:im_handle] = "MSN:someone"
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "MSN:someone"'
        expect( answer ).to eq( correct )
      end
      it "set 1st chat as im_handle" do
        attribs[:chat] = nil
        attribs[:imhandle] = "MSN:someone"
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "MSN:someone"'
        expect( answer ).to eq( correct )
      end
      it "set 1st chat as im" do
        attribs[:chat] = nil
        attribs[:im] = "MSN:someone"
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "MSN:someone"'
        expect( answer ).to eq( correct )
      end
      it "first chat without chat" do
        attribs[:chat]     = nil
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_create_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :chat/)
      end
      it "with empty chat" do
        attribs[:chat]     = ""
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_create_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :chat/)
      end

      it "append 2nd chat" do
        answer  = ext_od.send(:user_append_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone IMHandle "AIM:someone"'
        expect( answer ).to eq( correct )
      end
      it "second chat without chat" do
        attribs[:chat]     = nil
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_append_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :chat/)
      end
      it "with empty chat" do
        attribs[:chat]     = ""
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_append_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :chat/)
      end

      it "append multiple chats" do
        attribs[:chat] = ['AIM:someone', 'MSN:someone', 'ICQ:someone']
        answer  = ext_od.send(:user_set_chat, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "AIM:someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone IMHandle "MSN:someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone IMHandle "ICQ:someone"',
        ]
        expect( answer ).to eq( correct )
      end
      it "without chats" do
        attribs[:chat]     = nil
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_set_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /values: 'nil' invalid, value_name: :chats/)
      end
      it "without chats" do
        attribs[:chat]     = ""
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_set_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :chat/)
      end
      it "with chats empty" do
        attribs[:chat]     = []
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_set_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :chats/)
      end
    end

    describe "Set comment attribute" do
      it "comment - with comment" do
        answer  = ext_od.send(:user_set_comment, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Comment "Hi There"'
        expect( answer ).to eq( correct )
      end
      it "comment - with description" do
        attribs[:comment] = nil
        attribs[:description] = "Hi Buddy"
        answer  = ext_od.send(:user_set_comment, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Comment "Hi Buddy"'
        expect( answer ).to eq( correct )
      end
      it "without comment" do
        attribs[:comment]     = nil
        attribs[:description] = nil
        expect { ext_od.send(:user_set_comment, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :comment/)
      end
      it "with empty comment" do
        attribs[:comment]     = ""
        attribs[:description] = nil
        expect { ext_od.send(:user_set_comment, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :comment/)
      end
      it "with empty comment" do
        attribs[:comment]     = []
        attribs[:description] = nil
        expect { ext_od.send(:user_set_comment, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :comment/)
      end
    end

    describe "Set company attribute" do
      it "company - with company" do
        answer  = ext_od.send(:user_set_company, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Company "LAS"'
        expect( answer ).to eq( correct )
      end
      it "witout company" do
        attribs[:company] = nil
        expect { ext_od.send(:user_set_company, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :company/)
      end
      it "with empty comment" do
        attribs[:company] = ""
        expect { ext_od.send(:user_set_company, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :company/)
      end
      it "with empty comment" do
        attribs[:company] = []
        expect { ext_od.send(:user_set_company, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :company/)
      end
    end

    describe "Set country attribute" do
      it "country - with country" do
        answer  = ext_od.send(:user_set_country, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Country "CH"'
        expect( answer ).to eq( correct )
      end
      it "country - with c" do
        attribs[:country] = nil
        attribs[:c] = "DE"
        answer  = ext_od.send(:user_set_country, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Country "DE"'
        expect( answer ).to eq( correct )
      end
      it "witout country" do
        attribs[:country] = nil
        attribs[:c]       = nil
        expect { ext_od.send(:user_set_country, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :country/)
      end
    end

    describe "Set department attribute" do
      it "department - with department" do
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "IT"'
        expect( answer ).to eq( correct )
      end
      it "department - with dept" do
        attribs[:department] = nil
        attribs[:dept] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with deptnumber" do
        attribs[:department] = nil
        attribs[:deptnumber] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with dept_number" do
        attribs[:department] = nil
        attribs[:dept_number] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with departmentnumber" do
        attribs[:department] = nil
        attribs[:departmentnumber] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with department_number" do
        attribs[:department] = nil
        attribs[:department_number] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "witout department" do
        attribs[:department]        = nil
        attribs[:department_number] = nil
        expect { ext_od.send(:user_set_department, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :department/)
      end
    end

    describe "Set JobTitle" do
      it "with job_title" do
        answer  = ext_od.send(:user_set_job_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "DevOps"'
        expect( answer ).to eq( correct )
      end
      it "with jobtitle" do
        attribs[:job_title] = nil
        attribs[:jobtitle] = "Support"
        answer  = ext_od.send(:user_set_job_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "Support"'
        expect( answer ).to eq( correct )
      end
      it "with title" do
        attribs[:job_title] = nil
        attribs[:title] = "Support"
        answer  = ext_od.send(:user_set_job_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "Support"'
        expect( answer ).to eq( correct )
      end
      it "with title" do
        attribs[:job_title] = nil
        attribs[:title] = "Support"
        answer  = ext_od.send(:user_set_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "Support"'
        expect( answer ).to eq( correct )
      end
      it "witout job_title" do
        attribs[:job_title] = nil
        attribs[:title]     = nil
        expect { ext_od.send(:user_set_title, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :job_title/)
      end
    end

    describe "Set Keyword values" do
      it "set 1st keyword" do
        answer  = ext_od.send(:user_create_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "employee"'
        expect( answer ).to eq( correct )
      end
      it "set 1st keyword" do
        attribs[:keyword] = nil
        attribs[:keywords] = "departed"
        answer  = ext_od.send(:user_create_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "departed"'
        expect( answer ).to eq( correct )
      end
      it "witout keyword" do
        attribs[:keyword]  = nil
        attribs[:keywords] = nil
        expect { ext_od.send(:user_create_keyword, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :keyword/)
      end

      it "set 2nd keyword" do
        answer  = ext_od.send(:user_append_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "employee"'
        expect( answer ).to eq( correct )
      end
      it "set 2nd keyword" do
        attribs[:keyword] = nil
        attribs[:keywords] = "departed"
        answer  = ext_od.send(:user_append_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "departed"'
        expect( answer ).to eq( correct )
      end
      it "witout keyword" do
        attribs[:keyword]  = nil
        attribs[:keywords] = nil
        expect { ext_od.send(:user_append_keyword, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :keyword/)
      end

      it "set multi keyword" do
        attribs[:keyword] = ['employee', 'ops', 'it']
        answer  = ext_od.send(:user_set_keyword, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "employee"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "ops"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "it"',
          ]
        expect( answer ).to eq( correct )
      end
      it "set multi-keywords" do
        attribs[:keyword] = nil
        attribs[:keywords] = ['employee', 'ops', 'sis']
        answer  = ext_od.send(:user_set_keywords, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "employee"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "ops"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "sis"',
          ]
        expect( answer ).to eq( correct )
      end
      it "without keywords" do
        attribs[:keyword]  = nil
        attribs[:keywords] = nil
        expect { ext_od.send(:user_set_keywords, attribs, srv_info) }.
          to raise_error(ArgumentError, /values: 'nil' invalid, value_name: :keywords/)
      end
      it "with keywords empty" do
        attribs[:keyword]  = []
        attribs[:keywords] = nil
        expect { ext_od.send(:user_set_keywords, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :keywords/)
      end
    end

    describe "Set user_set_home_page" do
      it "with home_page" do
        attribs[:home_page] = 'http://las.ch'
        answer  = ext_od.send(:user_set_home_page, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone URL "http://las.ch"'
        expect( answer ).to eq( correct )
      end
      it "with homepage" do
        attribs[:home_page] = nil
        attribs[:homepage]  = 'http://www.las.ch'
        answer  = ext_od.send(:user_set_home_page, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone URL "http://www.las.ch"'
        expect( answer ).to eq( correct )
      end
      it "with web_page" do
        attribs[:home_page] = nil
        attribs[:homepage]  = nil
        attribs[:web_page]  = 'http://las.ch'
        answer  = ext_od.send(:user_set_home_page, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone URL "http://las.ch"'
        expect( answer ).to eq( correct )
      end
      it "with webpage" do
        attribs[:home_page] = nil
        attribs[:homepage]  = nil
        attribs[:web_page]  = nil
        attribs[:webpage]   = 'http://www.las.ch'
        answer  = ext_od.send(:user_set_home_page, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone URL "http://www.las.ch"'
        expect( answer ).to eq( correct )
      end
      it "witout home_page" do
        attribs[:home_page] = nil
        attribs[:homepage]  = nil
        attribs[:web_page]  = nil
        attribs[:webpage]   = nil
        expect { ext_od.send(:user_set_home_page, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :home_page/)
      end
    end

    describe "Set home_phone" do
      it "with home_phone" do
        answer  = ext_od.send(:user_set_home_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone HomePhoneNumber "024 654 1234"'
        expect( answer ).to eq( correct )
      end
      it "with home_phone_number" do
        attribs[:home_phone]        = nil
        attribs[:home_phone_number] = '024 567 8901'
        answer  = ext_od.send(:user_set_home_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone HomePhoneNumber "024 567 8901"'
        expect( answer ).to eq( correct )
      end
      it "witout home_phone" do
        attribs[:home_phone]        = nil
        attribs[:home_phone_number] = nil
        expect { ext_od.send(:user_set_home_phone, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :home_phone/)
      end
    end

    describe "Set mobile_phone" do
      it "with mobile_phone" do
        answer  = ext_od.send(:user_set_mobile_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MobileNumber "079 678 4321"'
        expect( answer ).to eq( correct )
      end
      it "with mobile_phone_number" do
        attribs[:mobile_phone] = nil
        attribs[:mobile_phone_number] = '079 678 9876'
        answer  = ext_od.send(:user_set_mobile_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MobileNumber "079 678 9876"'
        expect( answer ).to eq( correct )
      end
      it "witout mobile_phone" do
        attribs[:mobile_phone]        = nil
        attribs[:mobile_phone_number] = nil
        expect { ext_od.send(:user_set_mobile_phone, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :mobile_phone/)
      end
    end

    describe "Set work_phone" do
      it "with work_phone" do
        answer  = ext_od.send(:user_set_work_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PhoneNumber "x4890"'
        expect( answer ).to eq( correct )
      end
      it "with work_phone_number" do
        attribs[:work_phone] = nil
        attribs[:work_phone_number] = 'x1234'
        answer  = ext_od.send(:user_set_work_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PhoneNumber "x1234"'
        expect( answer ).to eq( correct )
      end
      it "witout work_phone" do
        attribs[:work_phone]        = nil
        attribs[:work_phone_number] = nil
        expect { ext_od.send(:user_set_work_phone, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :work_phone/)
      end
    end

    describe "Set name_suffix" do
      it "with name_suffix" do
        answer  = ext_od.send(:user_set_name_suffix, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NameSuffix "Jr"'
        expect( answer ).to eq( correct )
      end
      it "with suffix" do
        attribs[:name_suffix] = nil
        attribs[:suffix] = 'Sr'
        answer  = ext_od.send(:user_set_name_suffix, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NameSuffix "Sr"'
        expect( answer ).to eq( correct )
      end
      it "witout name_suffix" do
        attribs[:name_suffix] = nil
        attribs[:suffix]      = nil
        expect { ext_od.send(:user_set_name_suffix, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :name_suffix/)
      end
    end

    describe "Set organization_info" do
      it "with org_info" do
        answer  = ext_od.send(:user_set_organization_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone OrganizationInfo "Top"'
        expect( answer ).to eq( correct )
      end
      it "with organization_info" do
        attribs[:org_info] = nil
        attribs[:organization_info] = 'Down'
        answer  = ext_od.send(:user_set_organization_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone OrganizationInfo "Down"'
        expect( answer ).to eq( correct )
      end
      it "without organization_info" do
        attribs[:organization_info] = nil
        attribs[:org_info]          = nil
        expect { ext_od.send(:user_set_organization_info, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :organization_info/)
      end
    end

    describe "Set postal_code" do
      it "with postal_code" do
        answer  = ext_od.send(:user_set_postal_code, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PostalCode "1234"'
        expect( answer ).to eq( correct )
      end
      it "with zip_code" do
        attribs[:postal_code] = nil
        attribs[:zip_code] = '4321'
        answer  = ext_od.send(:user_set_postal_code, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PostalCode "4321"'
        expect( answer ).to eq( correct )
      end
      it "without postal_code" do
        attribs[:postal_code] = nil
        attribs[:zip_code]    = nil
        expect { ext_od.send(:user_set_postal_code, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :postal_code/)
      end
    end

    describe "Set relationships" do
      it "with relationships" do
        answer  = ext_od.send(:user_set_relationships, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Relationships "John"'
        expect( answer ).to eq( correct )
      end
      it "with relations" do
        attribs[:relationships] = nil
        attribs[:relations]     = 'Jane'
        answer  = ext_od.send(:user_set_relationships, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Relationships "Jane"'
        expect( answer ).to eq( correct )
      end
      it "without relationships" do
        attribs[:relationships] = nil
        attribs[:relations]     = nil
        expect { ext_od.send(:user_set_relationships, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :relationships/)
      end
    end

    describe "Set state" do
      it "with state" do
        answer  = ext_od.send(:user_set_state, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone State "Vaud"'
        expect( answer ).to eq( correct )
      end
      it "with state" do
        attribs[:state] = nil
        attribs[:st]    = "Wallis"
        answer  = ext_od.send(:user_set_state, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone State "Wallis"'
        expect( answer ).to eq( correct )
      end
      it "without state" do
        attribs[:state] = nil
        attribs[:st]    = nil
        expect { ext_od.send(:user_set_state, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :state/)
      end
    end

    describe "Set street" do
      it "with street" do
        answer  = ext_od.send(:user_set_street, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Street "chemin de la Source"'
        expect( answer ).to eq( correct )
      end
      it "with address" do
        attribs[:street] = nil
        attribs[:address] = 'Ave Rollier'
        answer  = ext_od.send(:user_set_address, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Street "Ave Rollier"'
        expect( answer ).to eq( correct )
      end
      it "without street" do
        attribs[:street]  = nil
        attribs[:address] = nil
        expect { ext_od.send(:user_set_address, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :street/)
      end
    end

    describe "Set weblog" do
      it "with weblog" do
        answer  = ext_od.send(:user_set_weblog, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone WeblogURI "http://example.ch/weblog"'
        expect( answer ).to eq( correct )
      end
      it "with blog" do
        attribs[:weblog] = nil
        attribs[:blog]   = 'http://example.com/blog'
        answer  = ext_od.send(:user_set_blog, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone WeblogURI "http://example.com/blog"'
        expect( answer ).to eq( correct )
      end
      it "without weblog" do
        attribs[:weblog] = nil
        attribs[:blog]   = nil
        expect { ext_od.send(:user_set_blog, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :weblog/)
      end
    end

    describe "user_add_to_group" do
      it "with user_name & group_membership" do
        attribs = {user_name: 'someone', group_membership: 'student'}
        answer  = ext_od.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with user_name & group_name" do
        attribs = {user_name: 'someone', group_name: 'student'}
        answer  = ext_od.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with username & groupname" do
        attribs = {username: 'someone', groupname: 'student'}
        answer  = ext_od.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with uid & gid" do
        attribs = {uid: 'someone', gid: 'student'}
        answer  = ext_od.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user student'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_remove_from_group" do
      it "with user_name & group_membership" do
        attribs = {user_name: 'someone', group_membership: 'student'}
        answer  = ext_od.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with user_name & group_name" do
        attribs = {user_name: 'someone', group_name: 'student'}
        answer  = ext_od.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with username & groupname" do
        attribs = {username: 'someone', groupname: 'student'}
        answer  = ext_od.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
      it "with uid & gid" do
        attribs = {uid: 'someone', gid: 'student'}
        answer  = ext_od.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -d someone -t user student'
        expect( answer ).to eq( correct )
      end
    end

  end
end
