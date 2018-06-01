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

    #   it "user_od_set_shell with default" do
    #     attribs = {uid: 'someone'}
    #     answer  = user.send(:user_od_set_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/bash"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_od_set_shell with params" do
    #     attribs = {uid: 'someone', shell: '/bin/zsh'}
    #     answer  = user.send(:user_od_set_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/zsh"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_od_set_shell with params" do
    #     attribs = {uid: 'someone', user_shell: '/bin/zsh'}
    #     answer  = user.send(:user_od_set_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/zsh"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_login_shell with default" do
    #     attribs = {uid: 'someone'}
    #     answer  = user.send(:user_set_login_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/bash"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_login_shell with params" do
    #     attribs = {uid: 'someone', shell: '/bin/zsh'}
    #     answer  = user.send(:user_set_login_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/zsh"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_login_shell with params" do
    #     attribs = {uid: 'someone', login_shell: '/bin/zsh'}
    #     answer  = user.send(:user_set_login_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/zsh"'
    #     expect( answer ).to eq( correct )
    #   end
    #
    #   it "user_set_email" do
    #     attribs = {uid: 'someone', email: 'user@example.com'}
    #     answer  = user.send(:user_set_email, attribs, srv_info)
    #     pp answer
    #     correct = [
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone mail "user@example.com"',
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone email "user@example.com"',
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone apple-user-mailattribute "user@example.com"'
    #     ]
    #     expect( answer ).to eq( correct )
    #   end
    #
    #   it "user_delete" do
    #     attribs = {uid: 'someone'}
    #     answer  = user.send(:user_delete, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Users/someone'
    #     expect( answer ).to eq( correct )
    #   end
    #   xit "user_create" do
    #     attribs = {uid: 'someone', email: 'user@example.com'}
    #     answer  = user.send(:user_set_email, attribs, srv_info)
    #     pp answer
    #     correct = [
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone',
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/zsh"',
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone mail "user@example.com"',
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone email "user@example.com"',
    #       '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone apple-user-mailattribute "user@example.com"'
    #     ]
    #     expect( answer ).to eq( correct )
    #   end
    #
    #   it "user_add_to_group" do
    #     attribs = {uid: 'someone', group_name: 'student'}
    #     answer  = user.send(:user_add_to_group, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/student GroupMembership someone'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_remove_from_group" do
    #     attribs = {uid: 'someone', group_name: 'student'}
    #     answer  = user.send(:user_remove_from_group, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/student GroupMembership someone'
    #     expect( answer ).to eq( correct )
    #   end
    # end
    #
    # describe "build ldap actions w/good data" do
    #   it "user_set_common_name" do
    #     attribs = {uid: 'someone', cn: "John Doe"}
    #     answer  = user.send(:user_set_common_name, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone cn "John Doe"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_uidnumber" do
    #     attribs = {uid: 'someone', uidnumber: 987654}
    #     answer  = user.send(:user_set_uidnumber, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone uidnumber 987654'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_gidnumber" do
    #     attribs = {uid: 'someone', gidnumber: 1045}
    #     answer  = user.send(:user_set_gidnumber, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone gidnumber 1045'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_home_directory" do
    #     attribs = {uid: 'someone', home_directory: 1043}
    #     answer  = user.send(:user_set_home_directory, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone homedirectory 1043'
    #     expect( answer ).to eq( correct )
    #   end
    #   # it "user_enable_login" do
    #   #   attribs = {uid: 'someone'}
    #   #   answer  = user.send(:user_enable_login, attribs, srv_info)
    #   #   correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
    #   #   # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=0"'
    #   #   expect( answer ).to eq( correct )
    #   # end
    #   # it "user_disable_login" do
    #   #   attribs = {uid: 'someone'}
    #   #   answer  = user.send(:user_disable_login, attribs, srv_info)
    #   #   correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
    #   #   # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=1"'
    #   #   expect( answer ).to eq( correct )
    #   # end
    #   it "user_od_set_shell" do
    #     attribs = {uid: 'someone'}
    #     answer  = user.send(:user_od_set_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/bash"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_od_set_shell with zsh" do
    #     attribs = {uid: 'someone', shell: '/bin/zsh'}
    #     answer  = user.send(:user_od_set_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone UserShell "/bin/zsh"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_login_shell" do
    #     attribs = {uid: 'someone'}
    #     answer  = user.send(:user_set_login_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/bash"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "user_set_login_shell with zsh" do
    #     attribs = {uid: 'someone', shell: '/bin/zsh'}
    #     answer  = user.send(:user_set_login_shell, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone loginShell "/bin/zsh"'
    #     expect( answer ).to eq( correct )
    #   end
    # end
    #
    # describe "errors when incorrect/missing data entered" do
    #   # user_od_set_real_name
    #   it "for user_od_set_real_name when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_od_set_real_name, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_od_set_real_name when real_name key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_od_set_real_name, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /real_name/)
    #   end
    #   it "for user_od_set_real_name when real_name space" do
    #     attribs = {uid: 'someone', real_name: " "}
    #     expect { user.send(:user_od_set_real_name, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /real_name/)
    #   end
    #   # user_set_common_name
    #   it "for user_set_common_name when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_set_common_name, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_set_common_name when common_name key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_set_common_name, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /common_name/)
    #   end
    #   it "for user_set_common_name when common_name blank" do
    #     attribs = {uid: 'someone', cn: " "}
    #     expect { user.send(:user_set_common_name, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /common_name/)
    #   end
    #   # user_set_od_unique_id
    #   it "for user_od_set_unique_id when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_od_set_unique_id, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_od_set_unique_id when unique_id key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_od_set_unique_id, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /unique_id/)
    #   end
    #   it "for user_od_set_unique_id when unique_id blank" do
    #     attribs = {uid: 'someone', unique_id: " "}
    #     expect { user.send(:user_od_set_unique_id, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /unique_id/)
    #   end
    #   # user_set_uidnumber
    #   it "for user_set_uidnumber when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_set_uidnumber, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_set_uidnumber when uidnumber key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_set_uidnumber, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uidnumber/)
    #   end
    #   it "for user_set_uidnumber when uidnumber blank" do
    #     attribs = {uid: 'someone', uidnumber: " "}
    #     expect { user.send(:user_set_uidnumber, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uidnumber/)
    #   end
    #   # user_set_od_unique_id
    #   it "for user_od_set_primary_group_id when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_od_set_primary_group_id, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_od_set_primary_group_id when primary_group_id key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_od_set_primary_group_id, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /primary_group_id/)
    #   end
    #   it "for user_od_set_primary_group_id when primary_group_id blank" do
    #     attribs = {uid: 'someone', primary_group_id: " "}
    #     expect { user.send(:user_od_set_primary_group_id, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /primary_group_id/)
    #   end
    #   # user_set_guidnumber
    #   it "for user_set_guidnumber when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_set_gidnumber, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_set_guidnumber when gidnumber key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_set_gidnumber, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /gidnumber/)
    #   end
    #   it "for user_set_guidnumber when gidnumber blank" do
    #     attribs = {uid: 'someone', gidnumber: " "}
    #     expect { user.send(:user_set_gidnumber, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /gidnumber/)
    #   end
    #   # user_od_set_nfs_home_directory
    #   it "for user_od_set_nfs_home_directory when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_od_set_nfs_home_directory, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_od_set_nfs_home_directory when nfs_home_directory key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_od_set_nfs_home_directory, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /nfs_home_directory/)
    #   end
    #   it "for user_od_set_nfs_home_directory when nfs_home_directory blank" do
    #     attribs = {uid: 'someone', nfs_home_directory: " "}
    #     expect { user.send(:user_od_set_nfs_home_directory, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /nfs_home_directory/)
    #   end
    #   # user_set_home_directoy
    #   it "for user_set_home_directory when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_set_home_directory, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_set_home_directory when home_directory key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_set_home_directory, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /home_directory/)
    #   end
    #   it "for user_set_home_directory when real_name blank" do
    #     attribs = {uid: 'someone', home_directory: " "}
    #     expect { user.send(:user_set_home_directory, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /home_directory/)
    #   end
    #   # user_set_password
    #   it "for user_set_password when password key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_set_password, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /password/)
    #   end
    #   it "for user_od_set_nfs_home_directory when password blank" do
    #     attribs = {uid: 'someone', password: " "}
    #     expect { user.send(:user_set_password, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /password/)
    #   end
    #   # user_verify_password
    #   it "for user_verify_password when uid key missing" do
    #     attribs = {}
    #     expect { user.send(:user_verify_password, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /uid/)
    #   end
    #   it "for user_verify_password when password key missing" do
    #     attribs = {uid: 'someone'}
    #     expect { user.send(:user_verify_password, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /password/)
    #   end
    #   it "for user_verify_password when password blank" do
    #     attribs = {uid: 'someone', password: " "}
    #     expect { user.send(:user_verify_password, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /password/)
    #   end
    # end

  end
end