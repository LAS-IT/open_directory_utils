require 'spec_helper'
require 'open_directory_utils'

RSpec.describe "Integrated - User Attribs" do

  let!(:od )          { OpenDirectoryUtils::Connection.new }

  let( :not_here_uid) { { uid: 'nobody' } }
  let( :min_user)     { { username: 'someone', unique_id: '9876543',
                          group_number: '1031', group_name: 'test',
                          chat: 'AIM:someone', keyword: 'employee'
                      } }
  let( :new_user)     { { username: 'someone', email: 'user@example.com',
                          first_name: 'Someone', last_name: "SPECIAL",
                          real_name: 'Someone (Very) SPECIAL',
                          unique_id: '9876543', group_number: '1031',
                          group_name: 'test', city: 'Leysin',
                          chat: ['AIM:someone','MSN:someone'],
                          comment: 'Hi There', company: 'LAS',
                          country: 'CH', department: 'IT',
                          job_title: 'DevOps',
                          keyword: ['employee','ops'],
                          home_phone: "024 654 1234",
                          mobile_phone: '079 678 4321', work_phone: 'x4890',
                          name_suffix: 'Jr', org_info: 'Top',
                          postal_code: '1234',
                          relationships: 'John', state: 'Vaud',
                          street: 'chemin de la Source, 3',
                          weblog: 'http://example.ch/weblog',
                      } }

  before(:each) do
    od.run(command: :user_create_min, params: new_user)
  end
  after(:each) do
    od.run(command: :user_delete, params: new_user)
  end

  context "live user attributes testing" do

    describe "user_set_city" do
      it "works" do
        setup   = od.run(command: :user_set_city, params: new_user)
        expect( setup[:error] ).to be nil
        answer  = od.run(command: :user_get_info, params: new_user)
        correct = "City: #{new_user[:city]}"
        expect( answer[:success].to_s ).to match( correct )
      end
      it "errors" do
        attribs        = new_user.dup
        attribs[:city] = nil
        answer  = od.run(command: :user_set_city, params: attribs)
        correct = "value: 'nil' invalid, value_name: :city"
        expect( answer[:success] ).to be nil
        expect( answer[:error].to_s ).to match( correct )
      end
    end

    describe "user_set_chat" do
      it "works" do
        setup   = od.run(command: :user_set_chat, params: new_user)
        expect( setup[:error] ).to be nil
        answer  = od.run(command: :user_get_info, params: new_user)
        correct = "IMHandle: #{new_user[:chat]}"
        expect( answer[:success].to_s ).to match( correct )
      end
      it "errors" do
        attribs        = new_user.dup
        attribs[:chat] = nil
        answer  = od.run(command: :user_set_chat, params: attribs)
        correct = "values: 'nil' invalid, value_name: :chats"
        expect( answer[:success] ).to be nil
        expect( answer[:error].to_s ).to match( correct )
      end
    end

    describe "user_set_comment" do
    end

    describe "user_set_company" do
    end

    describe "user_set_country" do
    end

    describe "user_set_department" do
    end

    describe "user_set_job_title" do
    end

    describe "user_set_keywords" do
      it "1"
      it "2"
      it "3"
    end

    describe "user_set_home_phone" do
    end

    describe "user_set_mobile_phone" do
    end

    describe "user_set_work_phone" do
    end

    describe "user_set_name_suffix" do
    end

    describe "user_set_organization_info" do
    end

    describe "user_set_postal_code" do
    end

    describe "user_set_relationships" do
    end

    describe "user_set_state" do
    end

    describe "user_set_street" do
    end

    describe "user_set_weblog" do
    end

  end
end
