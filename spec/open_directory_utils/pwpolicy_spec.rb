require 'spec_helper'
require "open_directory_utils/pwpolicy"

RSpec.describe OpenDirectoryUtils::Pwpolicy do

  context "build commands" do

    # before(:each) do
    #   # test module without loading real objects
    #   # https://www.ruby-forum.com/topic/171189
    #   @od = Object.new
    #   @od.extend(OpenDirectoryUtils::UserActions)
    #   @srv_info = {diradmin: 'diradmin', password: 'TopSecret',
    #                  data_path: '/LDAPv3/127.0.0.1/'}
    # end

    let(:policy)   { Object.new.extend(OpenDirectoryUtils::Pwpolicy) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe ":check_shortname check errors with bad shortname attribute" do
      it "shortname = nil" do
        attribs  = {shortname: nil}
        expect { policy.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname invalid/)
      end
      it "shortname = '' (blank)" do
        attribs = {shortname: ''}
        expect { policy.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname invalid/)
      end
      it "shortname = 'with space' (no space allowed)" do
        attribs = {shortname: 'with space'}
        expect { policy.send(:pwpolicy, attribs, srv_info) }.
            to raise_error(ArgumentError, /shortname invalid/)
      end
    end

    describe "pwpolicy self-built commands" do
      it "user_enable_login" do
        attribs = {shortname: 'someone', attribute: 'enableuser', value: nil}
        answer  = policy.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=0"'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {shortname: 'someone', attribute: 'disableuser', value: nil}
        answer  = policy.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=1"'
        expect( answer ).to eq( correct )
      end
    end

    describe "prebuild commands - enable / disable user" do
      it "user_enable_login" do
        attribs = {shortname: 'someone'}
        answer  = policy.send(:user_enable_login, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=0"'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {shortname: 'someone'}
        answer  = policy.send(:user_disable_login, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=1"'
        expect( answer ).to eq( correct )
      end
    end

  end
end
