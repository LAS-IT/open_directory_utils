require 'spec_helper'
require "open_directory_utils/clean_check"

RSpec.describe OpenDirectoryUtils::CleanCheck do

  context "build commands" do

    let(:od)       { Object.new.extend(OpenDirectoryUtils::CleanCheck) }
    let(:srv_info) { {diradmin: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1/',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy'} }

    describe ":check_uid check errors with bad uid attribute" do
      it "uid = nil" do
        attribs  = {uid: nil}
        expect { od.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /uid invalid/)
      end
      it "uid = '' (blank)" do
        attribs = {uid: ''}
        expect { od.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /uid invalid/)
      end
      it "uid = 'with space' (no space allowed)" do
        attribs = {uid: 'with space'}
        expect { od.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /uid invalid/)
      end
    end

    describe "build actions - fix extra spaces with uid" do
      let(:correct)  { {uid: 'someone'} }
      it "fixes uid with trailing space" do
        attribs = {uid: 'someone '}
        answer  = od.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: 'someone  '}
        answer  = od.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with leading space" do
        attribs = {uid: ' someone'}
        answer  = od.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: '  someone'}
        answer  = od.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing and leading spaces" do
        attribs = {uid: '  someone  '}
        answer  = od.send(:tidy_attribs, attribs)
        expect( answer ).to eq( correct )
      end
    end

  end
end
