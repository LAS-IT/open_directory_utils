require 'spec_helper'
require "open_directory_utils/commands_group"


RSpec.describe OpenDirectoryUtils::CommandsGroup do

  context "build commands" do

    let(:group)    { Object.new.extend(OpenDirectoryUtils::CommandsGroup) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe "group_get_info" do
      it "with od names" do
        attribs = {shortname: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with cn" do
        attribs = {cn: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
    end

    describe "group_exists?" do
      it "shortname" do
        attribs = {shortname: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "cn" do
        attribs = {cn: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "with gid" do
        attribs = {gid: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
    end

    describe "group_add_user" do
      it "with value" do
        attribs = {shortname: 'somegroup', value: 'newuser'}
        answer  = group.send(:group_add_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "with username" do
        attribs = {groupname: 'somegroup', username: 'newuser'}
        answer  = group.send(:group_add_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "with uid" do
        attribs = {cn: 'somegroup', uid: 'newuser'}
        answer  = group.send(:group_add_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
    end

    describe "group_remove_user" do
      it "using value" do
        attribs = {shortname: 'somegroup', value: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "using username" do
        attribs = {groupname: 'somegroup', username: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "using cn" do
        attribs = {cn: 'somegroup', uid: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "using uid" do
        attribs = {gid: 'somegroup', uid: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
    end

    describe "group_delete" do
      it "using shortname" do
        attribs = {shortname: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using record_name" do
        attribs = {record_name: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using gid" do
        attribs = {gid: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "using cn" do
        attribs = {cn: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
    end

    describe "group_create_min" do
      it "using good data" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    primary_group_id: "1032"}
        answer  = group.send(:group_create_min, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
    end

    xdescribe "group_create" do
      it "using good data" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    primary_group_id: "1032"}
        answer  = group.send(:group_create, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup passwd "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup RealName "Some Group"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup PrimaryGroupID "1032"',
        ]
        expect( answer ).to eq( correct )
      end
    end

  end
end
