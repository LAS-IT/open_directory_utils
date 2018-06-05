require 'spec_helper'
require "open_directory_utils/commands_group"


RSpec.describe OpenDirectoryUtils::CommandsGroup do

  context "build commands" do

    let(:group)    { Object.new.extend(OpenDirectoryUtils::CommandsGroup) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
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
      it "with cn & value" do
        attribs = {cn: 'somegroup', value: "junk"}
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
                    primary_group_id: "54321"}
        answer  = group.send(:group_create_min, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup'
        expect( answer ).to eq( correct )
      end
      it "missing shortname" do
        attribs = { real_name: "Some Group", primary_group_id: "54321"}
        expect { group.send(:group_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname: 'nil' invalid/)
      end
    end

    describe "group_set_primary_group_id" do
      it "with primary_group_id" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    primary_group_id: "54321"}
        answer  = group.send(:group_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup PrimaryGroupID "54321"'
        expect( answer ).to eq( correct )
      end
      it "with gidnumber" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    gidnumber: "54321"}
        answer  = group.send(:group_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup PrimaryGroupID "54321"'
        expect( answer ).to eq( correct )
      end
      it "with group_id" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    group_id: "54321"}
        answer  = group.send(:group_set_primary_group_id, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup PrimaryGroupID "54321"'
        expect( answer ).to eq( correct )
      end
      it "without shortname" do
        attribs = { real_name: "Some Group", group_id: "54321"}
        expect { group.send(:group_set_primary_group_id, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname: 'nil' invalid/)
      end
      it "without group_id" do
        attribs = { shortname: 'somegroup', real_name: "Some Group"}
        expect { group.send(:group_set_primary_group_id, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :group_id/)
      end
    end

    describe "group_set_passwd" do
      it "with password" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    primary_group_id: "54321", password: "TopSecret"}
        answer  = group.send(:group_set_passwd, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Groups/somegroup "TopSecret"'
        expect( answer ).to eq( correct )
      end
      it "with passwd" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    primary_group_id: "54321", passwd: "TopSecret"}
        answer  = group.send(:group_set_passwd, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Groups/somegroup "TopSecret"'
        expect( answer ).to eq( correct )
      end
      it "without password" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    primary_group_id: "54321"}
        answer  = group.send(:group_set_passwd, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Groups/somegroup "*"'
        expect( answer ).to eq( correct )
      end
      it "without shortname" do
        attribs = { }
        expect { group.send(:group_set_passwd, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname: 'nil' invalid/)
      end
    end

    describe "group_create" do
      it "using good data" do
        attribs = { shortname: 'somegroup', real_name: "Some Group",
                    primary_group_id: "54321"}
        answer  = group.send(:group_create, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup PrimaryGroupID "54321"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Groups/somegroup RealName "Some Group"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -passwd /Groups/somegroup "*"',
        ]
        expect( answer ).to eq( correct )
      end
    end

  end
end
