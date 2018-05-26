require 'spec_helper'

RSpec.describe "Integrated OpenDirectoryUtils User Commands" do

  let!(:od )       { OpenDirectoryUtils::Connection.new }
  let( :valid_uid) { {uid: 'btihen'} }

  context "query od info" do
    describe "without uid info" do
      it ""
    end
    describe "with valid uid info" do
      it "returns user info" do
        answer  = od.run(command: :user_get_info, attributes: valid_uid)
        correct = "email: #{valid_uid[:uid]}"
        expect( answer[:success].first ).to match( correct )
      end
      it "decide if user_exists?"
    end
    describe "with invalid uid info" do
      it "with internal space - get ERROR message"
    end
  end
  context "modify/update user info" do
    describe "without uid info" do
      it ""
    end
    describe "with valid input params" do
      it ""
    end
    describe "with invalid input params" do
      it ""
    end
  end
end
