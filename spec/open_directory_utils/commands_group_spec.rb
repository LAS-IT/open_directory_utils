require 'spec_helper'
require "open_directory_utils/commands_group"


RSpec.describe OpenDirectoryUtils::CommandsGroup do

  context "build commands" do

    let(:group)    { Object.new.extend(OpenDirectoryUtils::CommandsGroup) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy',
                      dsedit: '/usr/sbin/dseditgroup',
                    } }

    describe "group_get_info" do
      it "with group_name" do
        attribs = {group_name: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with group_membership" do
        attribs = {group_membership: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with groupmembership & value" do
        attribs = {groupmembership: 'somegroup', value: "junk"}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
    end

    describe "group_exists?" do
      it "group_name" do
        attribs = {group_name: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with gid" do
        attribs = {gid: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_membership" do
        attribs = {group_membership: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "groupmembership" do
        attribs = {groupmembership: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_in_group?" do
      it "with user_name & group_membership" do
        attribs = {user_name: 'someone', group_membership: 'student'}
        answer  = group.send(:user_in_group?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/student'
        expect( answer ).to eq( correct )
      end
      it "with user_name & groupmembership" do
        attribs = {user_name: 'someone', groupmembership: 'student'}
        answer  = group.send(:user_in_group?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/student'
        expect( answer ).to eq( correct )
      end
      it "with user_name & group_name" do
        attribs = {user_name: 'someone', group_name: 'student'}
        answer  = group.send(:user_in_group?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/student'
        expect( answer ).to eq( correct )
      end
      it "with username & groupname" do
        attribs = {username: 'someone', groupname: 'student'}
        answer  = group.send(:user_in_group?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/student'
        expect( answer ).to eq( correct )
      end
      it "with uid & gid" do
        attribs = {uid: 'someone', gid: 'student'}
        answer  = group.send(:user_in_group?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -read /Groups/student'
        expect( answer ).to eq( correct )
      end
    end
    
    describe "group_delete" do
      it "using group_name" do
        attribs = {group_name: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using gid" do
        attribs = {gid: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using cn" do
        attribs = {group_membership: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using record_name" do
        attribs = {record_name: 'somegroup'}
        # answer  = group.send(:group_delete, attribs, srv_info)
        expect { group.send(:group_delete, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
    end

    describe "group_create_min" do
      it "using good data" do
        attribs = { group_name: 'somegroup', real_name: "Some Group",
                    primary_group_id: "54321"}
        answer  = group.send(:group_create_min, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "missing shortname" do
        attribs = { real_name: "Some Group", primary_group_id: "54321"}
        expect { group.send(:group_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
    end

    describe "group_set_primary_group_id" do
      it "with primary_group_id" do
        attribs = { group_name: 'somegroup', long_name: "Some Group",
                    primary_group_id: "54321"}
        answer  = group.send(:group_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Groups/somegroup PrimaryGroupID "54321"'
        expect( answer ).to eq( correct )
      end
      it "with gidnumber" do
        attribs = { group_name: 'somegroup', real_name: "Some Group",
                    gidnumber: "54321"}
        answer  = group.send(:group_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Groups/somegroup PrimaryGroupID "54321"'
        expect( answer ).to eq( correct )
      end
      it "with group_id" do
        attribs = { group_name: 'somegroup', real_name: "Some Group",
                    group_id: "54321"}
        answer  = group.send(:group_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Groups/somegroup PrimaryGroupID "54321"'
        expect( answer ).to eq( correct )
      end
      it "without group_name" do
        attribs = { real_name: "Some Group", group_id: "54321"}
        expect { group.send(:group_set_primary_group_id, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "without group_id" do
        attribs = { group_name: 'somegroup', real_name: "Some Group"}
        expect { group.send(:group_set_primary_group_id, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :group_id/)
      end
    end

    # describe "group_set_passwd" do
    #   it "with password" do
    #     attribs = { group_name: 'somegroup', real_name: "Some Group",
    #                 primary_group_id: "54321", password: "TopSecret"}
    #     answer  = group.send(:group_set_passwd, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Groups/somegroup "TopSecret"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "with passwd" do
    #     attribs = { group_name: 'somegroup', real_name: "Some Group",
    #                 primary_group_id: "54321", passwd: "TopSecret"}
    #     answer  = group.send(:group_set_passwd, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Groups/somegroup "TopSecret"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "without password" do
    #     attribs = { group_name: 'somegroup', real_name: "Some Group",
    #                 primary_group_id: "54321"}
    #     answer  = group.send(:group_set_passwd, attribs, srv_info)
    #     correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Groups/somegroup "*"'
    #     expect( answer ).to eq( correct )
    #   end
    #   it "without shortname" do
    #     attribs = { }
    #     expect { group.send(:group_set_passwd, attribs, srv_info) }.
    #         to raise_error(ArgumentError, /record_name: 'nil' invalid/)
    #   end
    # end

    describe "group_create" do
      it "using good data" do
        attribs = { group_name: 'somegroup', real_name: "Some Group",
                    primary_group_id: "54321"}
        answer  = group.send(:group_create, attribs, srv_info)
        # pp answer
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Groups/somegroup',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Groups/somegroup PrimaryGroupID "54321"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Groups/somegroup RealName "Some Group"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Groups/somegroup "*"',
        ]
        expect( answer ).to eq( correct )
      end
    end

  end
end
