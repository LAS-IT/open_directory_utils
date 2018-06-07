require 'spec_helper'

RSpec.describe "Integrated OpenDirectoryUtils User Commands" do

  let!(:od )          { OpenDirectoryUtils::Connection.new }

  let( :existing_gid) { {gid: 'employee'} }
  let( :existing_uid) { {uid: 'btihen'} }

  let( :old_test_gid) { {gid: 'test'} }
  let( :not_here_gid) { {gid: 'nogroup'} }
  let( :new_group )   { {gid: 'odgrouptest', real_name: "OD Group TEST",
                          gidnumber: '54321'} }

  let( :not_here_uid) { {uid: 'nobody'} }
  let( :new_user)     { {uid: 'odusertest', uidnumber: 987654321,
                          first_name: "OD User", last_name: "TEST",
                          gidnumber: "1031", email: "user@example.com",
                          group_name: 'test'} }

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
        expect( answer.to_s ).to match( "record_name: 'nil' invalid" )
      end
    end

    describe "group_exists?" do
      it "answers true when group group_exists" do
        answer  = od.run(command: :group_exists?, params: old_test_gid)
        expect( answer[:success][:response] ).to eq( [true] )
      end
      it "answers false when group does not exist" do
        answer  = od.run(command: :group_exists?, params: not_here_gid)
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
        # correct = {:success=>{:response=>[true], :command=>:user_exists?, :attributes=>{:uid=>"btihen", :record_name=>"btihen"}}}
        # expect( answer ).to eq(correct)
        expect( answer[:success][:response] ).to eq( [true] )
      end
      it "answers false when user does not exist" do
        answer  = od.run(command: :user_exists?, params: not_here_uid)
        expect( answer[:success][:response] ).to eq( [false] )
      end
    end

    describe "create new odusertest" do
      after(:each) do
        od.run(command: :user_delete, params: new_user)
      end
      it "with minimal user" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success][:response] ).to eq( [false] )
        answer  = od.run(command: :user_create_min, params: new_user)
        details = od.run(command: :user_info, params: new_user)
        # pp details
        expect( answer[:success] ).not_to be(nil)
        expect( answer.to_s ).to match('odusertest')
      end
      it "with full user" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success][:response] ).to eq( [false] )
        answer  = od.run(command: :user_create_full, params: new_user)
        details = od.run(command: :user_info, params: new_user)
        # pp details
        expect( answer[:success] ).not_to be(nil)
        expect( answer.to_s ).to match('odusertest')
      end
      it "with full user" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success][:response] ).to eq( [false] )
        answer  = od.run(command: :user_create, params: new_user)
        details = od.run(command: :user_info, params: new_user)
        # pp details
        expect( answer[:success] ).not_to be(nil)
        expect( answer.to_s ).to match('odusertest')
      end
    end

    describe "set & test a users password" do
      # before - create a new account
      # after  - remove new account
      it "without error set's a password"
      it "verifies a know reset password"
    end

    describe "enable and disable user authentication" do
      # before - create a new account & set password
      # after  - remove new account
      it "verifies an account cannot authenticate"
      it "verifies an account can authenticate"
    end

    describe "delete od_test user" do
      before(:each) do
        od.run(command: :user_create_min, params: new_user)
      end
      it "with username" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success][:response] ).to eq( [true] )
        follow  = od.run(command: :user_delete, params: new_user)
        expect( follow[:success] ).not_to be(nil)
        no_acct = od.run(command: :user_exists?, params: new_user)
        expect( no_acct[:success][:response] ).to eq( [false] )
      end
    end
  end

  context "test existing user and group interactions" do
    # let(:params_emp) { {uid: 'lweisbecker', gid: 'employee'} }
    # let(:params_tst) { {uid: 'lweisbecker', gid: 'test'} }
    describe "user_in_group?" do
      it "verify existing user is in an existing group" do
        answer = od.run( command: :user_in_group?,
                          params: {uid: 'lweisbecker', gid: 'employee'} )
        # pp answer
        expect( answer.to_s ).to match('[true]')
        expect( answer[:success] ).not_to be( nil )
      end
      it "verify existing user is NOT in existing 'test' group" do
        answer = od.run( command: :user_in_group?,
                          params: {uid: 'lweisbecker', gid: 'test'} )
        expect( answer.to_s ).to match('[false]')
        expect( answer[:success] ).not_to be( nil )
      end
      it "verify non-existing user is NOT in existing 'test' group" do
        answer = od.run( command: :user_in_group?,
                          params:  {uid: 'nobody', gid: 'test'} )
        expect( answer.to_s ).to match('[false]')
        expect( answer[:success] ).not_to be( nil )
      end
      it "verify error when searching non-exitent group" do
        answer = od.run( command: :user_in_group?,
                          params: {uid: 'lweisbecker', gid: 'notthere'} )
        # pp answer
        expect( answer[:success] ).to   be( nil )
        expect( answer[:error] ).not_to be( nil )
        expect( answer.to_s ).to match('groupname invalid or missing')
      end
      it "verify error when searching non-exitent user" do
        answer = od.run( command: :user_in_group?,
                          params: {gid: 'test'} )
        # pp answer
        expect( answer[:success] ).to   be( nil )
        expect( answer[:error] ).not_to be( nil )
        expect( answer.to_s ).to match('username invalid or missing')
      end
    end
    describe "group_has_user?" do
      it "verify existing user is in an existing group" do
        answer = od.run( command: :group_has_user?,
                          params: {uid: 'lweisbecker', gid: 'employee'} )
        # pp answer
        expect( answer.to_s ).to match('[true]')
        expect( answer[:success] ).not_to be( nil )
      end
      it "verify existing user is NOT in existing 'test' group" do
        answer = od.run( command: :group_has_user?,
                          params: {uid: 'lweisbecker', gid: 'test'} )
        expect( answer.to_s ).to match('false')
        expect( answer[:success] ).not_to be( nil )
      end
      it "verify non-existing user is NOT in existing 'test' group" do
        answer = od.run( command: :group_has_user?,
                          params:  {uid: 'nobody', gid: 'test'} )
        expect( answer.to_s ).to match('[false]')
        expect( answer[:success] ).not_to be( nil )
      end
      it "verify error when searching non-exitent group" do
        answer = od.run( command: :group_has_user?,
                          params: {uid: 'lweisbecker', gid: 'notthere'} )
        # pp answer
        expect( answer[:success] ).to   be( nil )
        expect( answer[:error] ).not_to be( nil )
        expect( answer.to_s ).to match('groupname invalid or missing')
      end
      it "verify error when searching non-exitent user" do
        answer = od.run( command: :group_has_user?,
                          params: {gid: 'test'} )
        # pp answer
        expect( answer[:success] ).to   be( nil )
        expect( answer[:error] ).not_to be( nil )
        expect( answer.to_s ).to match('username invalid or missing')
      end
    end

    describe "user_append_to_group" do
      let(:params)  { {uid: 'odtestuser', gid: 'test'} }
      before(:each) do
        od.run( command: :user_create_min, params: params )
      end
      after(:each) do
        od.run( command: :user_remove_from_group, params: params )
        od.run( command: :user_delete, params: params )
      end
      it "add existing user to an existing 'test' group" do
        notthere = od.run( command: :user_in_group?, params: params )
        # pp notthere
        expect( notthere.to_s ).to match('false')
        answer = od.run( command: :user_append_to_group, params: params )
        # pp answer
        isthere = od.run( command: :group_has_user?, params: params )
        # pp isthere
        expect( isthere.to_s ).to match('true')
      end
      it "attribute error when remove user from group - when not in group" do
        params = {uid: 'testuser', gid: 'test'}
        notthere = od.run( command: :group_has_user?, params: params )
        # pp notthere
        expect( notthere.to_s ).to match('false')
        # expect( notthere.to_s ).to match('false')
        answer = od.run( command: :user_remove_from_group, params: params )
        # pp answer
        expect( answer.to_s ).to match('attribute status: eDSAttributeNotFound')
      end
    end
    describe "user_remove_from_group" do
      let(:params)  { {uid: 'odtestuser', gid: 'test'} }
      before(:each) do
        od.run( command: :user_create_min, params: params )
        od.run( command: :user_append_to_group, params: params )
      end
      after(:each) do
        od.run( command: :user_remove_from_group, params: params )
        od.run( command: :user_delete, params: params )
      end
      it "remove existing user from existing 'test' group" do
        isthere = od.run( command: :group_has_user?, params: params )
        # pp isthere
        expect( isthere.to_s ).to match('true')
        # expect( notthere.to_s ).to match('false')
        answer = od.run( command: :user_remove_from_group, params: params )
        # pp answer
        notthere = od.run( command: :group_has_user?, params: params )
        # pp notthere
        # expect( isthere.to_s ).to match('true')
        expect( notthere.to_s ).to match('false')
      end
      it "schema error when add existing user from already in group" do
        isthere = od.run( command: :group_has_user?, params: params )
        # pp isthere
        expect( isthere.to_s ).to match('true')
        # expect( notthere.to_s ).to match('false')
        answer = od.run( command: :user_append_to_group, params: params )
        # pp answer
        expect( answer.to_s ).to match('attribute status: eDSSchemaError')
        # notthere = od.run( command: :group_has_user?, params: params )
        # pp notthere
        # # expect( isthere.to_s ).to match('true')
        # expect( notthere.to_s ).to match('false')
      end
    end
  end

  xcontext "test new user and new group interactions" do
    before(:each) do
      od.run(command: :group_create_full, params: new_group)
      od.run(command: :user_create_full, params: new_user)
    end
    after(:each) do
      od.run(command: :user_delete, params: new_user)
      od.run(command: :group_delete, params: new_group)
    end
    xit "add first users to a new group" do

    end
    xit "add new user to new group with append insread of create" do

    end
  end

end
