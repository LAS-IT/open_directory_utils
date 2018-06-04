require 'spec_helper'

RSpec.describe "Integrated OpenDirectoryUtils User Commands" do

  let!(:od )          { OpenDirectoryUtils::Connection.new }
  let( :existing_uid) { {uid: 'btihen'} }
  let( :existing_gid) { {gid: 'employee'} }
  let( :not_here_uid) { {uid: 'nobody'} }

  context "query od info" do
    describe "without uid info" do
      it "o"
    end

    describe "user_get_info" do
      it "with existing user" do
        answer  = od.run(command: :user_get_info, params: existing_uid)
        correct = "email: #{existing_uid[:uid]}"
        expect( answer[:success][:response].first ).to match( correct )
      end
      it "with non-existing user" do
        answer  = od.run(command: :user_get_info, params: not_here_uid)
        correct = "eDSRecordNotFound"
        expect( answer[:error][:response].first ).to match( correct )
      end
    end

    describe "users_exists?" do
      it "answers true when user exists" do
        answer  = od.run(command: :user_exists?, params: existing_uid)
        correct = {:success=>{:response=>true, :command=>:user_exists?, :attributes=>{:uid=>"btihen", :shortname=>"btihen"}}}
        expect( answer ).to eq(correct)
      end
      it "answers false when user does not exist" do
        answer  = od.run(command: :user_exists?, params: not_here_uid)
        correct = {:success=>{:response=>false, :command=>:user_exists?, :attributes=>{:uid=>"nobody", :shortname=>"nobody"}}}
        expect( answer ).to eq(correct)
      end
    end

    describe "with invalid uid info" do
      it "with internal space - get ERROR message"
    end
  end
  context "modify/update user info" do
    describe "without uid info" do
      it "a"
    end
    describe "with valid input params" do
      it "b"
    end
    describe "with invalid input params" do
      it "c"
    end
  end
end
