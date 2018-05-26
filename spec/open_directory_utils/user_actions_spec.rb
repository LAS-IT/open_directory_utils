require 'spec_helper'

RSpec.describe OpenDirectoryUtils::UserActions do

  context "build commands" do
    before(:each) do
      @od = Object.new
      @od.extend(OpenDirectoryUtils::UserActions)
    end

    describe "with missing or bad uid attribute" do
      it "uid = nil" do
        attribs = {uid: nil}
        expect { @od.send(:check_uid, :user_get_info, attribs) }.
            to raise_error(ArgumentError, /missing uid/)
      end
      it "uid = '' (empty)" do
        attribs = {uid: ''}
        expect { @od.send(:check_uid, :user_get_info, attribs) }.
            to raise_error(ArgumentError, /blank uid/)
      end
      it "uid = 'with space' (no space allowed)" do
        attribs = {uid: 'with space'}
        expect { @od.send(:check_uid, :user_get_info, attribs) }.
            to raise_error(ArgumentError, /uid has space/)
      end
    end

    describe "fix extra spaces with uid" do
      it "fixes uid with trailing space" do
        attribs = {uid: 'someone '}
        answer  = @od.send(:check_uid, :user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: 'someone  '}
        answer  = @od.send(:check_uid, :user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with leading space" do
        attribs = {uid: ' someone'}
        answer  = @od.send(:check_uid, :user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: '  someone'}
        answer  = @od.send(:check_uid, :user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing and leading spaces" do
        attribs = {uid: '  someone  '}
        answer  = @od.send(:check_uid, :user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
    end

    describe " with valid attributes" do
      it "user_get_info" do
        attribs = {uid: 'someone'}
        answer  = @od.send(:user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "user_exists?" do
        attribs = {uid: 'someone'}
        answer  = @od.send(:user_exists?, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
    end

    describe "with invalid attributes" do
      # it ""
    end
  end

end
