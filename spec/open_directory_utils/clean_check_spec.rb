require 'spec_helper'
require "open_directory_utils/clean_check"

RSpec.describe OpenDirectoryUtils::CleanCheck do

  context "build commands" do

    let(:clean)    { Object.new.extend(OpenDirectoryUtils::CleanCheck) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe ":check_uid check errors with bad uid attribute" do
      it "uid is nil" do
        attribs  = {uid: nil}
        expect { clean.send(:check_critical_attribute, attribs, :uid) }.
            to raise_error(ArgumentError, /uid: 'nil' invalid/)
      end
      it "uid is '' (blank)" do
        attribs = {uid: ''}
        expect { clean.send(:check_critical_attribute, attribs, :uid) }.
            to raise_error(ArgumentError, /uid: '""' invalid/)
      end
      it "uid is 'with space' (no space allowed)" do
        attribs = {uid: 'with space'}
        expect { clean.send(:check_critical_attribute, attribs, :uid) }.
            to raise_error(ArgumentError, /uid: '"with space"' invalid/)
      end
      it "username is 'with space' (no space allowed)" do
        attribs = {username: 'with space'}
        expect { clean.send(:check_critical_attribute, attribs, :username) }.
            to raise_error(ArgumentError, /username: '"with space"' invalid/)
      end
      it "shortname 'with space' (no space allowed)" do
        attribs = {record_name: 'with space'}
        expect { clean.send(:check_critical_attribute, attribs, :record_name) }.
            to raise_error(ArgumentError, /record_name: '"with space"' invalid/)
      end
    end

    describe "build actions - fix extra spaces with uid" do
      let(:correct)  { {uid: 'someone'} }
      it "fixes uid with trailing space" do
        attribs = {uid: 'someone '}
        answer  = clean.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: 'someone  '}
        answer  = clean.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with leading space" do
        attribs = {uid: ' someone'}
        answer  = clean.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: '  someone'}
        answer  = clean.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing and leading spaces" do
        attribs = {uid: '  someone  '}
        answer  = clean.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
    end

  end
end
