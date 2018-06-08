require 'spec_helper'
require 'open_directory_utils'

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
                          group_name: 'test', enable: true} }

  context "live open directory user info testing" do
    describe "user_get_info" do
      it "with existing user" do
        answer  = od.run(command: :user_get_info, params: existing_uid)
        correct = "RecordName: #{existing_uid[:uid]}"
        expect( answer[:success].to_s ).to match( correct )
      end
        it "with existing user" do
          answer  = od.run(command: :user_info, params: existing_uid)
          correct = "RecordName: #{existing_uid[:uid]}"
          expect( answer[:success].to_s ).to match( correct )
        end
      it "with non-existing user" do
        answer  = od.run(command: :user_get_info, params: not_here_uid)
        correct = "eDSRecordNotFound"
        expect( answer[:error].to_s ).to match( correct )
      end
      it "without username" do
        answer  = od.run(command: :user_info, params: {})
        expect( answer[:success] ).to be( nil )
        expect( answer[:error].to_s ).to match( "record_name: 'nil' invalid" )
      end
    end

    describe "user_exists?" do
      it "answers true when user exists" do
        answer  = od.run(command: :user_exists?, params: existing_uid)
        expect( answer[:error] ).to be( nil )
        expect( answer[:success].to_s ).to match( 'true' )
      end
      it "answers false when user does not exist" do
        answer  = od.run(command: :user_exists?, params: not_here_uid)
        expect( answer[:error] ).to be( nil )
        expect( answer[:success].to_s ).to match( 'false')
      end
    end
  end

  context "live open directory group info testing" do
    describe "group_get_info" do
      it "with existing group" do
        answer  = od.run(command: :group_get_info, params: existing_gid)
        correct = "RecordName: #{existing_gid[:gid]}"
        expect( answer[:success].to_s ).to match( correct )
      end
      it "with existing group" do
        answer  = od.run(command: :group_info, params: existing_gid)
        correct = "RecordName: #{existing_gid[:gid]}"
        expect( answer[:success].to_s ).to match( correct )
      end
      it "with non-existing user" do
        answer  = od.run(command: :group_get_info, params: not_here_gid)
        correct = "eDSRecordNotFound"
        expect( answer[:error].to_s ).to match( correct )
      end
      it "without username" do
        answer  = od.run(command: :group_get_info, params: {})
        expect( answer[:success] ).to be( nil )
        expect( answer[:error].to_s ).to match( "record_name: 'nil' invalid" )
      end
    end

    describe "group_exists?" do
      it "answers true when group group_exists" do
        answer  = od.run(command: :group_exists?, params: old_test_gid)
        expect( answer[:success].to_s ).to match( 'true' )
      end
      it "answers false when group does not exist" do
        answer  = od.run(command: :group_exists?, params: not_here_gid)
        expect( answer[:success].to_s ).to match( 'false')
      end
    end
  end

  context "live user create / delete testing" do
    describe "create new odusertest" do
      after(:each) do
        od.run(command: :user_delete, params: new_user)
      end
      it "user_create_min" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success].to_s ).to match( 'false' )

        create  = od.run(command: :user_create_min, params: new_user)
        expect( create[:error] ).to be nil

        found  = od.run(command: :user_exists?, params: new_user)
        expect( found[:success].to_s ).to match('true')
      end
      it "user_create_full" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success].to_s ).to match( 'false' )

        create  = od.run(command: :user_create_full, params: new_user)
        # pp create
        expect( create[:error] ).to be nil

        found  = od.run(command: :user_exists?, params: new_user)
        expect( found[:success].to_s ).to match('true')
      end
      it "user_create" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success].to_s ).to match( 'false' )

        create = od.run(command: :user_create, params: new_user)
        # pp create
        expect( create[:error] ).to be nil

        found  = od.run(command: :user_exists?, params: new_user)
        expect( found[:success].to_s ).to match('true')
      end
    end
  end

  context "live group create / delete testing" do
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
        expect( details[:success].to_s ).to match( 'RecordName: odgrouptest' )
        answer  = od.run(command: :group_exists?, params: new_group)
        expect( answer[:success].to_s ).to match( 'true' )
      end
      it "full new_group" do
        success = od.run(command: :group_create_full, params: new_group)
        # pp success
        expect( success[:success] ).not_to eql( nil )
        details = od.run(command: :group_info, params: new_group)
        # pp details
        # expect( details.to_s ).to match( 'OD Group TEST' )
        expect( details[:success].to_s ).to match( 'OD Group TEST' )
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
        expect( answer[:success].to_s ).to match( 'false' )
      end
    end
  end

  context "live user edit testing" do
    describe "set & test a users password" do
      # before - create a new account
      before(:each) do
        od.run(command: :user_create_full, params: new_user)
      end
      after(:each) do
        od.run(command: :user_delete, params: new_user)
      end
      # after  - remove new account
      it "without error set's a password on an enabled account" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        expect( there[:success] ).to be_truthy
        od.run(command: :user_enable_login, params: {username: 'odusertest'})
        create = od.run(command: :user_set_password,
                        params: {username: 'odusertest', password: "T0p-Secret"})
        # pp create
        expect( create[:success] ).not_to be nil
        expect( create[:error] ).to be nil
      end
      it "fails to set password on disabled account" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        # pp there
        expect( there[:success] ).to be_truthy
        od.run(command: :user_disable_login, params: {username: 'odusertest'})
        create = od.run(command: :user_set_password,
                        params: {username: 'odusertest', password: "T0pSecret"})
        expect( create[:success] ).to be nil
        expect( create[:error].to_s ).to match('eDSAuthAccountDisabled')
      end
      it "without error set's a password" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        # pp there
        expect( there[:success] ).to be_truthy
        create = od.run(command: :user_set_password,
                        params: {username: 'odusertest', password: "T0p-Secret"})
        # pp create
        expect( create[:success] ).not_to be nil
        answer = od.run(command: :user_password_verified?,
                        params: {username: 'odusertest', password: "T0p-Secret"})
        # pp answer
        expect( answer[:success].to_s ).to match('true')
      end

      it "verifies bad password" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        # pp there
        expect( there[:success] ).to be_truthy
        create = od.run(command: :user_set_password,
                        params: {username: 'odusertest', password: "T0p-S3cret"})
        # pp create
        expect( create[:success] ).not_to be nil
        answer = od.run(command: :user_password_ok?,
                        params: {username: 'odusertest', password: "TopSecret"})
        # pp answer
        expect( answer[:success].to_s ).to match('false')
      end
    end

    describe "login policies for existing accounts" do
      it "verifies an active account is enabled with policy" do
        answer = od.run(command: :user_login_enabled?, params: {username: 'lweisbecker'})
        # pp answer
        expect( answer[:success].to_s ).to match('true')
        expect( answer[:error] ).to be nil
      end
      it "verifies an old retired account cann't login" do
        answer = od.run(command: :user_login_enabled?, params: {username: 'gbrown'})
        # pp answer
        expect( answer[:success].to_s ).to match('false')
        expect( answer[:error] ).to be nil
      end
      it "verifies a non-existing account can login" do
        answer = od.run(command: :user_login_enabled?, params: {username: 'odtest'})
        # pp answer
        expect( answer[:success] ).to be nil
        expect( answer[:error].to_s ).to match('Error: unknown AuthenticationAuthority')
      end
    end

    describe "enable and disable user account" do
      before(:each) do
        od.run(command: :user_create_full, params: new_user)
      end
      after(:each) do
        od.run(command: :user_delete, params: new_user)
      end
      it "verifies an account is enabled with password" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        expect( there[:success].to_s ).to match('true')

        enable = od.run(command: :user_enable_login, params: {username: 'odusertest'})
        expect( enable[:success] ).not_to be nil

        # pp od.run(command: :user_info, params: {username: 'odusertest'})
        passwd = od.run(command: :user_set_password,
                        params: {username: 'odusertest', password: "T0p-S3cret"})
        # pp passwd
        expect( passwd[:success] ).not_to be nil
        expect( passwd[:error] ).to be nil
      end
      it "verifies a new account is enabled with policy" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        expect( there[:success].to_s ).to match('true')

        enable = od.run(command: :user_enable_login, params: {username: 'odusertest'})
        expect( enable[:success] ).not_to be nil

        # why doesn't 'odusertest' has NO policies in this case?
        # pp od.run(command: :user_get_policy, params: {username: 'odusertest'})
        answer = od.run(command: :user_login_enabled?, params: {username: 'odusertest'})
        expect( answer[:success].to_s ).to match('true')
      end
      it "verifies an account is disabled with password" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        expect( there[:success].to_s ).to match('true')

        enable = od.run(command: :user_disable_login, params: {username: 'odusertest'})
        expect( enable[:success] ).not_to be nil

        # pp od.run(command: :user_info, params: {username: 'odusertest'})
        passwd = od.run(command: :user_set_password,
                        params: {username: 'odusertest', password: "T0p-S3cret"})
        # pp passwd
        expect( passwd[:success] ).to be nil
        expect( passwd[:error].to_s ).to match(/eDSAuthAccountDisabled/)
      end
      it "verifies an account is disabled with policy" do
        there  = od.run(command: :user_exists?, params: {username: 'odusertest'})
        expect( there[:success].to_s ).to match('true')

        blocked = od.run(command: :user_disable_login, params: {username: 'odusertest'})
        expect( blocked[:success] ).not_to be nil

        answer = od.run(command: :user_login_enabled?, params: {username: 'odusertest'})
        # pp answer
        expect( answer[:success].to_s ).to match('false')
        expect( answer[:error] ).to be nil
      end
    end

    describe "delete od_test user" do
      before(:each) do
        od.run(command: :user_create_min, params: new_user)
      end
      it "with username" do
        account = od.run(command: :user_exists?, params: new_user)
        expect( account[:success].to_s ).to match( 'true' )
        follow  = od.run(command: :user_delete, params: new_user)
        expect( follow[:success] ).not_to be(nil)
        no_acct = od.run(command: :user_exists?, params: new_user)
        expect( no_acct[:success].to_s ).to match( 'false' )
      end
    end
  end

  context "user in group reads" do
    # let(:params_emp) { {uid: 'lweisbecker', gid: 'employee'} }
    # let(:params_tst) { {uid: 'lweisbecker', gid: 'test'} }
    describe "user_in_group?" do
      it "verify existing user is in an existing group" do
        answer = od.run( command: :user_in_group?,
                          params: {uid: 'lweisbecker', gid: 'employee'} )
        # pp answer
        expect( answer[:success].to_s ).to match('true')
      end
      it "verify existing user is NOT in existing 'test' group" do
        answer = od.run( command: :user_in_group?,
                          params: {uid: 'lweisbecker', gid: 'test'} )
        expect( answer[:success].to_s ).to match('false')
      end
      it "verify non-existing user is NOT in existing 'test' group" do
        answer = od.run( command: :user_in_group?,
                          params:  {uid: 'nobody', gid: 'test'} )
        expect( answer[:success].to_s ).to match('false')
      end
      it "verify error when searching non-exitent group" do
        answer = od.run( command: :user_in_group?,
                          params: {uid: 'lweisbecker', gid: 'notthere'} )
        correct = 'eDSRecordNotFound'
        expect( answer[:error].to_s ).to match( correct )
      end
      it "verify error when searching missing username" do
        answer = od.run( command: :user_in_group?,
                          params: {gid: 'test'} )
        correct = "value: 'nil' invalid, value_name: :username"
        expect( answer[:error].to_s ).to match( correct )
      end
    end
  end

  context "edit user into & out of groups" do
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

end
