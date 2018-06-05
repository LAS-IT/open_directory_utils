require 'spec_helper'

RSpec.describe "Integrated OpenDirectoryUtils User Commands" do

  let!(:od )          { OpenDirectoryUtils::Connection.new }

  let( :existing_gid) { {gid: 'employee'} }
  let( :not_here_gid) { {gid: 'nogroup'} }
  let( :new_group )   { {gid: 'odgrouptest', real_name: "OD Group TEST",
                          gidnumber: '54321'} }

  let( :existing_uid) { {uid: 'btihen'} }
  let( :not_here_uid) { {uid: 'nobody'} }
  let( :new_user_r_n) { {uid: 'odusertest', real_name: "OD User TEST",
                          uidnumber: 987654321, gidnumber: "1031",
                          email: "user@example.com"} }
  let( :new_user_fnl) { {uid: 'od_util_test', uidnumber: 987654321,
                          first_name: "OD User", last_name: "TEST",
                          gidnumber: "1031", email: "user@example.com"} }

  context "live open directory group testing" do
    describe "group_get_info" do
      it "with existing group" do
        answer  = od.run(command: :group_get_info, params: existing_gid)
        correct = "RecordName: #{existing_gid[:gid]}"
        expect( answer[:success][:response].first ).to match( correct )
      end
      it "with existing group" do
        answer  = od.run(command: :group_info, params: existing_gid)
        correct = "RecordName: #{existing_gid[:gid]}"
        expect( answer[:success][:response].first ).to match( correct )
      end
      it "with non-existing user" do
        answer  = od.run(command: :group_get_info, params: not_here_gid)
        correct = "eDSRecordNotFound"
        expect( answer[:error][:response].first ).to match( correct )
      end
      it "without username" do
        answer  = od.run(command: :group_get_info, params: {})
        expect( answer[:success] ).to be( nil )
        expect( answer.to_s ).to match( "shortname: 'nil' invalid" )
      end
    end

    describe "group_exists?" do
      it "answers true when group group_exists" do
        answer  = od.run(command: :group_exists?, params: existing_gid)
        correct = {:success=>{:response=>[true], :command=>:group_exists?, :attributes=>{:gid=>"employee", :shortname=>"employee"}}}
        expect( answer ).to eq(correct)
        expect( answer[:success][:response] ).to eq( [true] )
      end
      it "answers false when group does not exist" do
        answer  = od.run(command: :group_exists?, params: not_here_gid)
        correct = {:success=>{:response=>[false], :command=>:group_exists?, :attributes=>{:gid=>"nogroup", :shortname=>"nogroup"}}}
        expect( answer ).to eq(correct)
        expect( answer[:success][:response] ).to eq( [false] )
      end
    end

    describe "create group" do
      after(:each) do
        od.run(command: :group_delete, params: new_group)
      end
      it "minimal new_group" do
        success = od.run(command: :group_create_min, params: new_group)
        # pp success
        expect( success[:success] ).not_to be( nil )
        details = od.run(command: :group_info, params: new_group)
        # pp details
        # expect( details.to_s ).to match( 'RecordName: odgrouptest' )
        expect( details[:success][:response].to_s ).to match( 'RecordName: odgrouptest' )
        answer  = od.run(command: :group_exists?, params: new_group)
        expect( answer[:success][:response] ).to eq( [true] )
      end
      it "full new_group" do
        success = od.run(command: :group_create_full, params: new_group)
        # pp success
        expect( success[:success] ).not_to eql( nil )
        details = od.run(command: :group_info, params: new_group)
        # pp details
        # expect( details.to_s ).to match( 'OD Group TEST' )
        expect( details[:success][:response].to_s ).to match( 'OD Group TEST' )
      end
    end

    describe "delete od_test user" do
      before(:each) do
        od.run(command: :group_create_min, params: new_group)
      end
      it "with new_group" do
        answer0 = od.run(command: :group_delete, params: new_group)
        expect( answer0[:success] ).not_to eql( nil )
        answer  = od.run(command: :group_exists?, params: new_group)
        expect( answer[:success][:response] ).to eq( [false] )
      end
    end
  end

  context "live open directory user testing" do
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
        correct = {:success=>{:response=>[true], :command=>:user_exists?, :attributes=>{:uid=>"btihen", :shortname=>"btihen"}}}
        expect( answer ).to eq(correct)
        expect( answer[:success][:response] ).to eq( [true] )
      end
      it "answers false when user does not exist" do
        answer  = od.run(command: :user_exists?, params: not_here_uid)
        correct = {:success=>{:response=>[false], :command=>:user_exists?, :attributes=>{:uid=>"nobody", :shortname=>"nobody"}}}
        expect( answer ).to eq(correct)
        expect( answer[:success][:response] ).to eq( [false] )
      end
    end

    describe "create new minimal od_test user" do
      it "with username" do

      end
    end
    describe "delete od_test user" do
      it "with username" do
      end
    end
  end

  context "test users and groups together" do
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
