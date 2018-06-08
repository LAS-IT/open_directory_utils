require 'spec_helper'
require "open_directory_utils/commands_user_attribs_ldap"

RSpec.describe OpenDirectoryUtils::CommandsUserAttribsLdap do

  context "build commands" do

    let(:user)     { Object.new.extend(OpenDirectoryUtils::CommandsUserAttribsLdap) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe "user_set_common_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with real_name" do
        attribs = {username: 'someone', real_name: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with realname" do
        attribs = {uid: 'someone', realname: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "with first and lastname" do
        attribs = {uid: 'someone', first_name: "John", last_name: "DOE"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone cn "John DOE"'
        expect( answer ).to eq( correct )
      end
      it "with cn" do
        attribs = {uid: 'someone', cn: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_given_name" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "John"}
        answer  = user.send(:user_set_given_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone givenName "John"'
        expect( answer ).to eq( correct )
      end
      it "with real_name" do
        attribs = {username: 'someone', first_name: "John"}
        answer  = user.send(:user_set_given_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone givenName "John"'
        expect( answer ).to eq( correct )
      end
      it "with realname" do
        attribs = {uid: 'someone', given_name: "John"}
        answer  = user.send(:user_set_given_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone givenName "John"'
        expect( answer ).to eq( correct )
      end
      it "without first name" do
        attribs = {uid: 'someone', last_name: "DOE"}
        expect { user.send(:user_set_given_name, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :given_name/)
      end
    end

    describe "user_set_surname" do
      it "with user_name" do
        attribs = {user_name: 'someone', value: "Doe"}
        answer  = user.send(:user_set_surname, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone sn "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with last_name" do
        attribs = {username: 'someone', last_name: "Doe"}
        answer  = user.send(:user_set_sn, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone sn "Doe"'
        expect( answer ).to eq( correct )
      end
      it "with surname" do
        attribs = {uid: 'someone', surname: "DOE"}
        answer  = user.send(:user_set_surname, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone sn "DOE"'
        expect( answer ).to eq( correct )
      end
      it "with surname" do
        attribs = {uid: 'someone', sn: "DOE"}
        answer  = user.send(:user_set_sn, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone sn "DOE"'
        expect( answer ).to eq( correct )
      end
      it "without surname" do
        attribs = {uid: 'someone', first_name: "John"}
        expect { user.send(:user_set_surname, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :surname/)
      end
    end

    describe "user_set_uidnumber" do
      it "with uniqueid" do
        attribs = {user_name: 'someone', uniqueid: 987654}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
      it "with unique_id" do
        attribs = {username: 'someone', unique_id: 987654}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
      it "with uidnumber" do
        attribs = {uid: 'someone', uidnumber: "987654"}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
      it "with value" do
        attribs = {uid: 'someone', value: "987654"}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_gidnumber" do
      it "using primary_group_id" do
        attribs = {uid: 'someone', primary_group_id: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
      it "using group_id" do
        attribs = {uid: 'someone', group_id: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
      it "using gidnumber" do
        attribs = {uid: 'someone', gidnumber: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_home_directory" do
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', nfs_home_directory: "/home/someone"}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone homedirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', home_directory: "/home/someone"}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone homedirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: "/home/someone"}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone homedirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using nfs_home_directory" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone homedirectory "/Volumes/Macintosh HD/Users/someone"'
        expect( answer ).to eq( correct )
      end
    end

    define "user_set_login_shell" do
      it "with default" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_login_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone loginShell "/bin/bash"'
        expect( answer ).to eq( correct )
      end
      it "with shell" do
        attribs = {uid: 'someone', shell: '/bin/zsh'}
        answer  = user.send(:user_set_login_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone loginShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
      it "with login_shell" do
        attribs = {uid: 'someone', login_shell: '/bin/zsh'}
        answer  = user.send(:user_set_login_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone loginShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
    end

  end
end
