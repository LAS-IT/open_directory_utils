require 'spec_helper'
require "open_directory_utils/commands_group"


RSpec.describe OpenDirectoryUtils::CommandsGroup do

  context "build commands" do

    let(:group)    { Object.new.extend(OpenDirectoryUtils::CommandsGroup) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe "build od actions w/good data" do
      it "group_get_info - with od names" do
        attribs = {shortname: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_get_info - with groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_get_info - with ldapnames" do
        attribs = {cn: 'somegroup'}
        answer  = group.send(:group_get_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end

      it "group_exists? - with od names" do
        attribs = {shortname: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_exists? - with groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_exists? - with ldapnames" do
        attribs = {cn: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_exists? - with gid" do
        attribs = {gid: 'somegroup'}
        answer  = group.send(:group_exists?, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Groups/somegroup'
        expect( answer ).to eq( correct )
      end

      it "group_add_user - with od names" do
        attribs = {shortname: 'somegroup', value: 'newuser'}
        answer  = group.send(:group_add_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "group_add_user - with groupname" do
        attribs = {groupname: 'somegroup', username: 'newuser'}
        answer  = group.send(:group_add_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "group_add_user - with ldapnames" do
        attribs = {cn: 'somegroup', uid: 'newuser'}
        answer  = group.send(:group_add_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "group_add_user - with gid" do
        attribs = {gid: 'somegroup', uid: 'newuser'}
        answer  = group.send(:group_add_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end

      it "group_remove_user - w/standard data" do
        attribs = {shortname: 'somegroup', value: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "group_remove_user - with groupname" do
        attribs = {groupname: 'somegroup', username: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "group_remove_user - with ldapnames" do
        attribs = {cn: 'somegroup', uid: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end
      it "group_remove_user - with gid" do
        attribs = {gid: 'somegroup', uid: 'newuser'}
        answer  = group.send(:group_remove_user, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup GroupMembership "newuser"'
        expect( answer ).to eq( correct )
      end

      it "group_delete - w/standard data" do
        attribs = {shortname: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_delete - with groupname" do
        attribs = {groupname: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_delete - with ldapnames" do
        attribs = {cn: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "group_delete - with cn" do
        attribs = {gid: 'somegroup'}
        answer  = group.send(:group_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -delete /Groups/somegroup'
        expect( answer ).to eq( correct )
      end

      it "group_create - w/standard data" do
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
      it "group_create - with groupname" do
        attribs = { groupname: 'somegroup', real_name: "Some Group",
                    groupnumber: "1032"}
        answer  = group.send(:group_create, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup passwd "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup RealName "Some Group"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup PrimaryGroupID "1032"',
        ]
        expect( answer ).to eq( correct )
      end
      it "group_create - with ldapnames" do
        attribs = { cn: 'somegroup', apple_group_realname: "Some Group",
                    gidnumber: "1032"}
        answer  = group.send(:group_create, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup passwd "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup RealName "Some Group"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup PrimaryGroupID "1032"',
        ]
        expect( answer ).to eq( correct )
      end
      it "group_create - with gid" do
        attribs = { gid: 'somegroup', apple_group_realname: "Some Group",
                    gidnumber: "1032"}
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
