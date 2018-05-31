require 'spec_helper'
require "open_directory_utils/pwpolicy_user"

RSpec.describe OpenDirectoryUtils::PwpolicyUser do

  context "build commands" do

    # before(:each) do
    #   # test module without loading real objects
    #   # https://www.ruby-forum.com/topic/171189
    #   @od = Object.new
    #   @od.extend(OpenDirectoryUtils::UserActions)
    #   @srv_info = {diradmin: 'diradmin', password: 'TopSecret',
    #                  data_path: '/LDAPv3/127.0.0.1/'}
    # end

    let(:policy)   { Object.new.extend(OpenDirectoryUtils::PwpolicyUser) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe ":check_uid check errors with bad uid attribute" do
      it "uid = nil" do
        attribs  = {uid: nil}
        expect { policy.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /uid invalid/)
      end
      it "uid = '' (blank)" do
        attribs = {uid: ''}
        expect { policy.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /uid invalid/)
      end
      it "uid = 'with space' (no space allowed)" do
        attribs = {uid: 'with space'}
        expect { policy.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /uid invalid/)
      end
    end

    describe "pwpolicy self-built commands" do
      it "user_enable_login" do
        attribs = {uid: 'someone', attribute: 'enableuser', value: nil}
        answer  = policy.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=0"'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {uid: 'someone', attribute: 'disableuser', value: nil}
        answer  = policy.send(:pwpolicy, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=1"'
        expect( answer ).to eq( correct )
      end
    end

    describe "prebuild commands - enable / disable user" do
      it "user_enable_login" do
        attribs = {uid: 'someone'}
        answer  = policy.send(:user_enable_login, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=0"'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {uid: 'someone'}
        answer  = policy.send(:user_disable_login, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=1"'
        expect( answer ).to eq( correct )
      end
    end

  end
end
