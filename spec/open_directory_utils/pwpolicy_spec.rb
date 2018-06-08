require 'spec_helper'
require "open_directory_utils/pwpolicy"

RSpec.describe OpenDirectoryUtils::Pwpolicy do

  context "build commands" do

    let(:policy)   { Object.new.extend(OpenDirectoryUtils::Pwpolicy) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

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

    describe "prebuild commands - enable / disable user" do
      it "user_enable_login" do
        attribs = {record_name: 'someone'}
        answer  = policy.send(:user_enable_login, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -enableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=0"'
        expect( answer ).to eq( correct )
      end
      it "user_disable_login" do
        attribs = {record_name: 'someone'}
        answer  = policy.send(:user_disable_login, attribs, srv_info)
        correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -disableuser'
        # correct = '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -u someone -setpolicy "isDisabled=1"'
        expect( answer ).to eq( correct )
      end
    end

  end
end
