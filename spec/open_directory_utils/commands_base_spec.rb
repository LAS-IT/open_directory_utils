require 'spec_helper'
require "open_directory_utils/commands_base"

RSpec.describe OpenDirectoryUtils::CommandsBase do

  context "dscl commands" do

    let(:dscl)     { Object.new.extend(OpenDirectoryUtils::CommandsBase) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe "errors with incorrect shortname" do
      it "empty hash" do
        attribs  = {}
        expect { dscl.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "nil" do
        attribs  = {record_name: nil}
        expect { dscl.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "'' (blank)" do
        attribs = {record_name: ''}
        expect { dscl.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '""' invalid/)
      end
      it "'with space' (no space allowed)" do
        attribs = {record_name: 'with space'}
        expect { dscl.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '"with space"' invalid/)
      end
    end

    describe "errors with incorrect action" do
      it "nil" do
        attribs  = {record_name: 'valid', action: nil, scope: 'Users'}
        expect { dscl.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /action: 'nil' invalid/)
      end
    end

    describe "errors with incorrect scope" do
      it "'with space' (no space allowed)" do
        attribs  = {record_name: 'valid', action: 'valid', scope: 'with space'}
        expect { dscl.send(:dscl, attribs, srv_info) }.
            to raise_error(ArgumentError, /scope: '"with space"' invalid/)
      end
    end

    describe "build actions - fix extra spaces with shortname" do
      it "fixes shortname with trailing space" do
        attribs = {record_name: 'someone ', action: 'read', scope: 'Users'}
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with trailing spaces" do
        attribs = {record_name: 'someone  ', action: 'read', scope: 'Users'}
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with leading space" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    attribute: nil, value: nil}
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with trailing spaces" do
        attribs = {record_name: '  someone', action: 'read', scope: 'Users'}
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "fixes shortname with trailing and leading spaces" do
        attribs = {record_name: '  someone  ', action: 'read', scope: 'Users'}
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "build dscl actions" do
      it "read base user (nil attributes, return text)" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    attribute: nil, value: nil, format: nil }
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "read base user (return xml)" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    format: 'xml' }
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -plist -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "read base user (return text)" do
        attribs = { record_name: ' someone', action: 'read', scope: 'Users',
                    format: 'text' }
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -read /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "create base user (no other attributes, return text)" do
        attribs = { record_name: ' someone', action: 'create', scope: 'Users'}
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "create user first keyword (return text)" do
        attribs = { record_name: ' someone', action: 'create', scope: 'Users',
                    attribute: 'keyword', value: 'student', format: 'text' }
        answer  = dscl.send(:dscl, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1/ -create /Users/someone keyword "student"'
        expect( answer ).to eq( correct )
      end
      it "append user second keyword (return xml)" do
        attribs = { record_name: ' someone', action: 'append', scope: 'Users',
                    attribute: 'keyword', value: 'departed', format: 'plist' }
        answer  = dscl.send(:dscl, attribs, srv_info)
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

    describe "pwpolicy self-built commands" do
      it "user_enable_login" do
        attribs = {record_name: 'someone', attribute: 'enableuser', value: nil}
        answer  = policy.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=0"'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {record_name: 'someone', attribute: 'disableuser', value: nil}
        answer  = policy.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=1"'
        expect( answer ).to eq( correct )
      end
    end

    describe ":check_record_name check errors with bad shortname attribute" do
      it "shortname is nil" do
        attribs  = {record_name: nil}
        expect { policy.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "shortname is '' (blank)" do
        attribs = {record_name: ''}
        expect { policy.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '""' invalid/)
      end
      it "shortname = 'with space' (no space allowed)" do
        attribs = {record_name: 'with space'}
        expect { policy.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: '"with space"' invalid/)
      end
    end

  end
end
