require 'spec_helper'
require "open_directory_utils/commands_base"

RSpec.describe OpenDirectoryUtils::CommandsBase do

  let(:base)     { Object.new.extend(OpenDirectoryUtils::CommandsBase) }
  let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                    data_path: '/LDAPv3/127.0.0.1/',
                    dscl: '/usr/bin/dscl',
                    pwpol: '/usr/bin/pwpolicy',
                    dsedit: '/usr/bin/dseditgroup'} }

  context "dscl commands" do
    describe "errors with incorrect shortname" do
      it "empty hash" do
        attribs  = {}
        expect { base.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "nil" do
        attribs  = {record_name: nil}
        expect { base.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "'' (blank)" do
        attribs = {record_name: ''}
        expect { base.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '""' invalid/)
      end
      it "'with space' (no space allowed)" do
        attribs = {record_name: 'with space'}
        expect { base.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '"with space"' invalid/)
      end
    end

    describe "errors with incorrect action" do
      it "nil" do
        attribs  = {record_name: 'valid', action: nil, scope: 'Users'}
        expect { base.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /action: 'nil' invalid/)
      end
    end

    describe "errors with incorrect scope" do
      it "'with space' (no space allowed)" do
        attribs  = {record_name: 'valid', action: 'valid', scope: 'with space'}
        expect { base.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /scope: '"with space"' invalid/)
      end
    end

    describe "build actions - fix extra spaces with shortname" do
      it "fixes shortname with trailing space" do
        attribs = {record_name: 'someone ', action: 'read', scope: 'Users'}
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with trailing spaces" do
        attribs = {record_name: 'someone  ', action: 'read', scope: 'Users'}
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with leading space" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    attribute: nil, value: nil}
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with trailing spaces" do
        attribs = {record_name: '  someone', action: 'read', scope: 'Users'}
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with trailing and leading spaces" do
        attribs = {record_name: '  someone  ', action: 'read', scope: 'Users'}
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "build dscl actions" do
      it "check user membership" do
        attribs = { record_name: 'someone', action: 'read', scope: 'Users',
                    attribute: nil, value: nil, format: nil }
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "read base user (nil attributes, return text)" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    attribute: nil, value: nil, format: nil }
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "read base user (return xml)" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    format: 'xml' }
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -plist -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "read base user (return text)" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    format: 'text' }
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "create base user (no other attributes, return text)" do
        attribs = { record_name: ' someone', action: 'create', scope: 'Users'}
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "create user first keyword (return text)" do
        attribs = { record_name: ' someone', action: 'create', scope: 'Users',
                    attribute: 'keyword', value: 'student', format: 'text' }
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone keyword "student"'
        expect( answer ).to eq( correct )
      end
      it "append user second keyword (return xml)" do
        attribs = { record_name: ' someone', action: 'append', scope: 'Users',
                    attribute: 'keyword', value: 'departed', format: 'plist' }
        answer  = base.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -plist -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -append /Users/someone keyword "departed"'
        expect( answer ).to eq( correct )
      end
    end
  end

  context "pwpolicy commands" do
    let(:policy)   { Object.new.extend(OpenDirectoryUtils::CommandsBase) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe "pwpolicy built by hand" do
      it "user_enable_login" do
        attribs = {record_name: 'someone', attribute: 'enableuser', value: nil}
        answer  = base.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1/ -u someone -enableuser'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {record_name: 'someone', attribute: 'disableuser', value: nil}
        answer  = base.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1/ -u someone -disableuser'
        expect( answer ).to eq( correct )
      end
    end

    describe ":check_record_name check errors with bad shortname attribute" do
      it "shortname is nil" do
        attribs  = {record_name: nil}
        expect { base.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "shortname is '' (blank)" do
        attribs = {record_name: ''}
        expect { base.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '""' invalid/)
      end
      it "shortname = 'with space' (no space allowed)" do
        attribs = {record_name: 'with space'}
        expect { base.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '"with space"' invalid/)
      end
    end
  end

  context "test dseditgroup" do
    describe "dseditgroup build by hand" do
      it "all good data - check user membership" do
        attribs = { operation: 'checkmember', value: 'groupname',
                    record_name: 'username'}
        answer  = base.send(:dseditgroup, attribs, srv_info)
        correct = '/usr/bin/dseditgroup -o checkmember -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1/ -m username groupname'
        expect( answer ).to eq( correct )
      end
      it "check user membership - with extra info" do
        attribs = { operation: 'checkmember', value: 'groupname',
                    record_name: 'username', action: 'add', type: 'user'}
        answer  = base.send(:dseditgroup, attribs, srv_info)
        correct = '/usr/bin/dseditgroup -o checkmember -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1/ -m username groupname'
        expect( answer ).to eq( correct )
      end
      it "all good data - to add a user" do
        attribs = { operation: 'edit', value: 'groupname',
                    record_name: 'username', action: 'add', type: 'user'}
        answer  = base.send(:dseditgroup, attribs, srv_info)
        correct = '/usr/bin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1/ -a username -t user groupname'
        expect( answer ).to eq( correct )
      end
      it "all good data - to remove a user" do
        attribs = { operation: 'edit', value: 'groupname',
                    record_name: 'username', action: 'delete', type: 'user'}
        answer  = base.send(:dseditgroup, attribs, srv_info)
        correct = '/usr/bin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1/ -d username -t user groupname'
        expect( answer ).to eq( correct )
      end
      it "all good data - create a group" do
        attribs = { operation: 'create', value: 'groupname', real_name: 'Group Name'}
        answer  = base.send(:dseditgroup, attribs, srv_info)
        correct = '/usr/bin/dseditgroup -o create -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1/ -r "Group Name" groupname'
        expect( answer ).to eq( correct )
      end
      it "all good data - create a group - no realname" do
        attribs = { operation: 'create', value: 'groupname'}
        answer  = base.send(:dseditgroup, attribs, srv_info)
        correct = '/usr/bin/dseditgroup -o create -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1/ -r "groupname" groupname'
        expect( answer ).to eq( correct )
      end
      it "all good data - delete a group" do
        attribs = { operation: 'delete', value: 'groupname'}
        answer  = base.send(:dseditgroup, attribs, srv_info)
        correct = '/usr/bin/dseditgroup -o delete -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1/ groupname'
        expect( answer ).to eq( correct )
      end
    end

    describe "errors adding user to a group" do
      it "operation is nil" do
        attribs = { operation: nil, value: 'groupname',
                    record_name: 'username', action: 'add', type: 'user'}
        expect { base.send(:dseditgroup, attribs, srv_info) }.
            to raise_error(ArgumentError, /operation: 'nil' invalid/)
      end
      it "groupname is nil" do
        attribs = { operation: 'edit', value: nil,
                    record_name: 'username', action: 'add', type: 'user'}
        expect { base.send(:dseditgroup, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid/)
      end
      it "edit - username is nil" do
        attribs = { operation: 'edit', value: 'groupname',
                    record_name: nil, action: 'add', type: 'user'}
        expect { base.send(:dseditgroup, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "edit - action is nil" do
        attribs = { operation: 'edit', value: 'groupname',
                    record_name: 'username', action: nil, type: 'user'}
        expect { base.send(:dseditgroup, attribs, srv_info) }.
            to raise_error(ArgumentError, /action: 'nil' invalid/)
      end
      it "edit - type is nil" do
        attribs = { operation: 'edit', value: 'groupname',
                    record_name: 'username', action: 'add', type: nil}
        expect { base.send(:dseditgroup, attribs, srv_info) }.
            to raise_error(ArgumentError, /type: 'nil' invalid/)
      end
    end
  end

end
