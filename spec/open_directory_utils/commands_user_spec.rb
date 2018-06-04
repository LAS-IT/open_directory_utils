require 'spec_helper'

RSpec.describe OpenDirectoryUtils::CommandsUser do

  context "build commands" do

    let(:user)     { Object.new.extend(OpenDirectoryUtils::CommandsUser) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe "user_get_info" do
      it "with shortname" do
        attribs = {shortname: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with username" do
        attribs = {username: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with uid" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra value" do
        attribs = {uid: 'someone', value: 'nothing'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra attribute" do
        attribs = {uid: 'someone', attribute: 'nothing'}
        answer  = user.send(:user_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_get_info" do
      it "user_exists? - shortname" do
        attribs = {shortname: 'someone'}
        answer  = user.send(:user_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_real_name" do
      it "user_set_real_name - value" do
        attribs = {shortname: 'someone', value: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_real_name - real_name" do
        attribs = {username: 'someone', real_name: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_real_name - realname" do
        attribs = {uid: 'someone', realname: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_real_name - value" do
        attribs = {uid: 'someone', value: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_real_name - cn" do
        attribs = {uid: 'someone', cn: "John Doe"}
        answer  = user.send(:user_set_real_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
    end
    describe "user_set_common_name" do
      it "user_set_common_name - value" do
        attribs = {shortname: 'someone', value: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_common_name - real_name" do
        attribs = {username: 'someone', real_name: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_common_name - realname" do
        attribs = {uid: 'someone', realname: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_common_name - value" do
        attribs = {uid: 'someone', value: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_set_common_name - cn" do
        attribs = {uid: 'someone', cn: "John Doe"}
        answer  = user.send(:user_set_common_name, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_unique_id" do
      it "with uniqueid" do
        attribs = {shortname: 'someone', uniqueid: 987654}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with unique_id" do
        attribs = {username: 'someone', unique_id: 987654}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with uidnumber" do
        attribs = {uid: 'someone', uidnumber: "987654"}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
      it "with value" do
        attribs = {uid: 'someone', value: "987654"}
        answer  = user.send(:user_set_unique_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UniqueID "987654"'
        expect( answer ).to eq( correct )
      end
    end
    describe "user_set_uidnumber" do
      it "with uniqueid" do
        attribs = {shortname: 'someone', uniqueid: 987654}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
      it "with unique_id" do
        attribs = {username: 'someone', unique_id: 987654}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
      it "with uidnumber" do
        attribs = {uid: 'someone', uidnumber: "987654"}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
      it "with value" do
        attribs = {uid: 'someone', value: "987654"}
        answer  = user.send(:user_set_uidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone uidnumber "987654"'
        expect( answer ).to eq( correct )
      end
    end


    describe "user_set_primary_group_id" do
      it "using primary_group_id" do
        attribs = {uid: 'someone', primary_group_id: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using group_id" do
        attribs = {uid: 'someone', group_id: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using gidnumber" do
        attribs = {uid: 'someone', gidnumber: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 1043}
        answer  = user.send(:user_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone PrimaryGroupID "1043"'
        expect( answer ).to eq( correct )
      end
    end
    describe "user_set_gidnumber" do
      it "using primary_group_id" do
        attribs = {uid: 'someone', primary_group_id: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
      it "using group_id" do
        attribs = {uid: 'someone', group_id: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
      it "using gidnumber" do
        attribs = {uid: 'someone', gidnumber: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 1043}
        answer  = user.send(:user_set_gidnumber, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone gidnumber "1043"'
        expect( answer ).to eq( correct )
      end
    end


    describe "user_od_set_nfs_home_directory" do
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', nfs_home_directory: "/home/someone"}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', home_directory: "/home/someone"}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: "/home/someone"}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone NFSHomeDirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using blank" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_nfs_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"'
        expect( answer ).to eq( correct )
      end
    end
    describe "user_set_home_directory" do
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', nfs_home_directory: "/home/someone"}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone homedirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using nfs_home_directory" do
        attribs = {uid: 'someone', home_directory: "/home/someone"}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone homedirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: "/home/someone"}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone homedirectory "/home/someone"'
        expect( answer ).to eq( correct )
      end
      it "using nfs_home_directory" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_home_directory, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone homedirectory "/Volumes/Macintosh HD/Users/someone"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_password" do
      it "using password" do
        attribs = {uid: 'someone', password: 'A-Big-Secret'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using passwd" do
        attribs = {uid: 'someone', passwd: 'A-Big-Secret'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 'A-Big-Secret'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Users/someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using no value" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_password, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Users/someone "*"'
        expect( answer ).to eq( correct )
      end
    end
    describe "user_verify_password" do
      it "using password" do
        attribs = {uid: 'someone', password: 'A-Big-Secret'}
        answer  = user.send(:user_verify_password, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1/ -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using passwd" do
        attribs = {uid: 'someone', passwd: 'A-Big-Secret'}
        answer  = user.send(:user_verify_password, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1/ -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
      it "using value" do
        attribs = {uid: 'someone', value: 'A-Big-Secret'}
        answer  = user.send(:user_verify_password, attribs, srv_info)
        correct = '/usr/bin/dscl /LDAPv3/127.0.0.1/ -auth someone "A-Big-Secret"'
        expect( answer ).to eq( correct )
      end
    end

    define "user_set_shell" do
      it "with default" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/bash"'
        expect( answer ).to eq( correct )
      end
      it "with shell" do
        attribs = {uid: 'someone', shell: '/bin/zsh'}
        answer  = user.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
      it "with user_shell" do
        attribs = {uid: 'someone', user_shell: '/bin/zsh'}
        answer  = user.send(:user_set_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
    end
    define "user_set_login_shell" do
      it "with default" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_set_login_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/bash"'
        expect( answer ).to eq( correct )
      end
      it "with shell" do
        attribs = {uid: 'someone', shell: '/bin/zsh'}
        answer  = user.send(:user_set_login_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
      it "with login_shell" do
        attribs = {uid: 'someone', login_shell: '/bin/zsh'}
        answer  = user.send(:user_set_login_shell, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/zsh"'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_set_email" do
      it "user_set_email with 'apple-user-mailattribute'" do
        attribs = {uid: 'someone', 'apple-user-mailattribute' => 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone mail "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone email "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with apple_user_mailattribute" do
        attribs = {uid: 'someone', apple_user_mailattribute: 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone mail "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone email "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with apple_user_mailattribute" do
        attribs = {uid: 'someone', email: 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone mail "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone email "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
      it "user_set_email with mail" do
        attribs = {uid: 'someone', mail: 'user@example.com'}
        answer  = user.send(:user_set_email, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone mail "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone email "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone apple-user-mailattribute "user@example.com"'
        ]
        expect( answer ).to eq( correct )
      end
    end

    describe "user_delete" do
      it "with uid" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with username" do
        attribs = {username: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with shortname" do
        attribs = {shortname: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra attribute" do
        attribs = {shortname: 'someone', attribute: 'nothing'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra value" do
        attribs = {shortname: 'someone', value: 'nothing'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_create_min" do
      it "with needed uid" do
        attribs = { uid: 'someone'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with needed username" do
        attribs = { username: 'someone'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with needed shortname" do
        attribs = { shortname: 'someone'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with all attributes" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra attributes - no uid" do
        attribs = { email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        expect { user.send(:user_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname: 'nil' invalid/)
      end
      it "with missing shortname" do
        attribs = { }
        expect { user.send(:user_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname: 'nil' invalid/)
      end
    end

    describe "user_create_full" do
      let(:correct) {[
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Users/someone "*"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/bash"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone RealName "Someone Special"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UniqueID "9876543"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone PrimaryGroupID "1032"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone mail "user@example.com"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone email "user@example.com"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone apple-user-mailattribute "user@example.com"',
      ]}
      it "with good attributes" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        answer  = user.send(:user_create_full, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with missing attributes (no username)" do
        attribs = { gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        expect { user.send(:user_create_full, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname: 'nil' invalid/)
      end
      it "with missing attributes (no email)" do
        attribs = { uid: 'someone', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        expect {  user.send(:user_create_full, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :email/)
      end
      it "with missing attributes (no PrimaryGroupID)" do
        attribs = { uid: 'someone', email: 'user@example.com',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        expect { user.send(:user_create_full, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :group_id/)
      end
      it "with missing attributes (no real name)" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    uniqueid: '9876543'}
        expect { user.send(:user_create_full, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :real_name/)
      end
      it "with missing attributes (no uniqueid)" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special'}
        expect { user.send(:user_create_full, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :unique_id/)
      end
    end

    describe "user_add_to_group" do
      it "group student" do
        attribs = {uid: 'someone', group_name: 'student'}
        answer  = user.send(:user_add_to_group, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/student GroupMembership someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_remove_from_group" do
      it "user_remove_from_group" do
        attribs = {uid: 'someone', group_name: 'student'}
        answer  = user.send(:user_remove_from_group, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/student GroupMembership someone'
        expect( answer ).to eq( correct )
      end
    end

  end
end
