require 'spec_helper'
require "open_directory_utils/dscl"

RSpec.describe OpenDirectoryUtils::Dscl do

  context "build commands" do

    # before(:each) do
    #   # test module without loading real objects
    #   # https://www.ruby-forum.com/topic/171189
    #   @od = Object.new
    #   @od.extend(OpenDirectoryUtils::UserActions)
    #   @srv_info = {diradmin: 'diradmin', password: 'TopSecret',
    #                  data_path: '/LDAPv3/127.0.0.1/'}
    # end

    let(:dscl)     { Object.new.extend(OpenDirectoryUtils::Dscl) }
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
end
