require 'spec_helper'
require "open_directory_utils/commands_user_attribs"

RSpec.describe OpenDirectoryUtils::CommandsUserAttribs do

  context "build commands for syncing extended user attributes" do

    let(:ext_od)   { Object.new.extend(OpenDirectoryUtils::CommandsUserAttribs) }
    let(:attribs)  { {username: 'someone', email: 'user@example.com',
                      first_name: 'Someone', last_name: "SPECIAL",
                      real_name: 'Someone (Very) SPECIAL', unique_id: '9876543',
                      group_number: '1032', group_name: 'test', city: 'Leysin',
                      chat: 'AIM:someone', comment: 'Hi There', company: 'LAS',
                      country: 'CH', department: 'IT', job_title: 'DevOps',
                      keyword: 'employee', home_phone: "024 654 1234",
                      mobile_phone: '079 678 4321', work_phone: 'x4890',
                      name_suffix: 'Jr', org_info: 'Top', postal_code: '1234',
                      relationships: 'John', state: 'Vaud',
                      street: 'chemin de la Source',
                      weblog: 'http://example.ch/weblog',
                    } }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy',
                      dsedit: '/usr/sbin/dseditgroup'} }

    describe "Set city attribute" do
      it "city - with city" do
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Leysin"'
        expect( answer ).to eq( correct )
      end
      it "city - with town" do
        attribs[:city] = nil
        attribs[:town] = "Aigle"
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Aigle"'
        expect( answer ).to eq( correct )
      end
      it "city - with locale" do
        attribs[:city] = nil
        attribs[:locale] = "Aigle"
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Aigle"'
        expect( answer ).to eq( correct )
      end
      it "city - with l" do
        attribs[:city] = nil
        attribs[:l] = "Aigle"
        answer  = ext_od.send(:user_set_city, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone City "Aigle"'
        expect( answer ).to eq( correct )
      end
      it "witout city" do
        attribs[:city] = nil
        attribs[:town] = nil
        expect { ext_od.send(:user_set_city, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :city/)
      end
      it "with empty city" do
        attribs[:city] = ""
        attribs[:town] = nil
        expect { ext_od.send(:user_set_city, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :city/)
      end
    end

    describe "Set Chat values" do
      it "set 1st chat" do
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "AIM:someone"'
        expect( answer ).to eq( correct )
      end
      it "set 1st chat as im_handle" do
        attribs[:chat] = nil
        attribs[:im_handle] = "MSN:someone"
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "MSN:someone"'
        expect( answer ).to eq( correct )
      end
      it "set 1st chat as im_handle" do
        attribs[:chat] = nil
        attribs[:imhandle] = "MSN:someone"
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "MSN:someone"'
        expect( answer ).to eq( correct )
      end
      it "set 1st chat as im" do
        attribs[:chat] = nil
        attribs[:im] = "MSN:someone"
        answer  = ext_od.send(:user_create_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "MSN:someone"'
        expect( answer ).to eq( correct )
      end
      it "first chat without chat" do
        attribs[:chat]     = nil
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_create_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :chat/)
      end
      it "with empty chat" do
        attribs[:chat]     = ""
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_create_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :chat/)
      end

      it "append 2nd chat" do
        answer  = ext_od.send(:user_append_chat, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone IMHandle "AIM:someone"'
        expect( answer ).to eq( correct )
      end
      it "second chat without chat" do
        attribs[:chat]     = nil
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_append_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :chat/)
      end
      it "with empty chat" do
        attribs[:chat]     = ""
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_append_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :chat/)
      end

      it "append multiple chats" do
        attribs[:chat] = ['AIM:someone', 'MSN:someone', 'ICQ:someone']
        answer  = ext_od.send(:user_set_chat, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone IMHandle "AIM:someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone IMHandle "MSN:someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone IMHandle "ICQ:someone"',
        ]
        expect( answer ).to eq( correct )
      end
      it "without chats" do
        attribs[:chat]     = nil
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_set_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /values: 'nil' invalid, value_name: :chats/)
      end
      it "without chats" do
        attribs[:chat]     = ""
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_set_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :chat/)
      end
      it "with chats empty" do
        attribs[:chat]     = []
        attribs[:imhandle] = nil
        expect { ext_od.send(:user_set_chat, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :chats/)
      end
    end

    describe "Set comment attribute" do
      it "comment - with comment" do
        answer  = ext_od.send(:user_set_comment, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Comment "Hi There"'
        expect( answer ).to eq( correct )
      end
      it "comment - with description" do
        attribs[:comment] = nil
        attribs[:description] = "Hi Buddy"
        answer  = ext_od.send(:user_set_comment, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Comment "Hi Buddy"'
        expect( answer ).to eq( correct )
      end
      it "without comment" do
        attribs[:comment]     = nil
        attribs[:description] = nil
        expect { ext_od.send(:user_set_comment, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :comment/)
      end
      it "with empty comment" do
        attribs[:comment]     = ""
        attribs[:description] = nil
        expect { ext_od.send(:user_set_comment, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :comment/)
      end
      it "with empty comment" do
        attribs[:comment]     = []
        attribs[:description] = nil
        expect { ext_od.send(:user_set_comment, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :comment/)
      end
    end

    describe "Set company attribute" do
      it "company - with company" do
        answer  = ext_od.send(:user_set_company, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Company "LAS"'
        expect( answer ).to eq( correct )
      end
      it "witout company" do
        attribs[:company] = nil
        expect { ext_od.send(:user_set_company, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :company/)
      end
      it "with empty comment" do
        attribs[:company] = ""
        expect { ext_od.send(:user_set_company, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: '""' invalid, value_name: :company/)
      end
      it "with empty comment" do
        attribs[:company] = []
        expect { ext_od.send(:user_set_company, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :company/)
      end
    end

    describe "Set country attribute" do
      it "country - with country" do
        answer  = ext_od.send(:user_set_country, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Country "CH"'
        expect( answer ).to eq( correct )
      end
      it "country - with c" do
        attribs[:country] = nil
        attribs[:c] = "DE"
        answer  = ext_od.send(:user_set_country, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Country "DE"'
        expect( answer ).to eq( correct )
      end
      it "witout country" do
        attribs[:country] = nil
        attribs[:c]       = nil
        expect { ext_od.send(:user_set_country, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :country/)
      end
    end

    describe "Set department attribute" do
      it "department - with department" do
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "IT"'
        expect( answer ).to eq( correct )
      end
      it "department - with dept" do
        attribs[:department] = nil
        attribs[:dept] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with deptnumber" do
        attribs[:department] = nil
        attribs[:deptnumber] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with dept_number" do
        attribs[:department] = nil
        attribs[:dept_number] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with departmentnumber" do
        attribs[:department] = nil
        attribs[:departmentnumber] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "department - with department_number" do
        attribs[:department] = nil
        attribs[:department_number] = "Math"
        answer  = ext_od.send(:user_set_department, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Department "Math"'
        expect( answer ).to eq( correct )
      end
      it "witout department" do
        attribs[:department]        = nil
        attribs[:department_number] = nil
        expect { ext_od.send(:user_set_department, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :department/)
      end
    end

    describe "Set JobTitle" do
      it "with job_title" do
        answer  = ext_od.send(:user_set_job_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "DevOps"'
        expect( answer ).to eq( correct )
      end
      it "with jobtitle" do
        attribs[:job_title] = nil
        attribs[:jobtitle] = "Support"
        answer  = ext_od.send(:user_set_job_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "Support"'
        expect( answer ).to eq( correct )
      end
      it "with title" do
        attribs[:job_title] = nil
        attribs[:title] = "Support"
        answer  = ext_od.send(:user_set_job_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "Support"'
        expect( answer ).to eq( correct )
      end
      it "with title" do
        attribs[:job_title] = nil
        attribs[:title] = "Support"
        answer  = ext_od.send(:user_set_title, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone JobTitle "Support"'
        expect( answer ).to eq( correct )
      end
      it "witout job_title" do
        attribs[:job_title] = nil
        attribs[:title]     = nil
        expect { ext_od.send(:user_set_title, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :job_title/)
      end
    end

    describe "Set Keyword values" do
      it "set 1st keyword" do
        answer  = ext_od.send(:user_create_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "employee"'
        expect( answer ).to eq( correct )
      end
      it "set 1st keyword" do
        attribs[:keyword] = nil
        attribs[:keywords] = "departed"
        answer  = ext_od.send(:user_create_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "departed"'
        expect( answer ).to eq( correct )
      end
      it "witout keyword" do
        attribs[:keyword]  = nil
        attribs[:keywords] = nil
        expect { ext_od.send(:user_create_keyword, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :keyword/)
      end

      it "set 2nd keyword" do
        answer  = ext_od.send(:user_append_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "employee"'
        expect( answer ).to eq( correct )
      end
      it "set 2nd keyword" do
        attribs[:keyword] = nil
        attribs[:keywords] = "departed"
        answer  = ext_od.send(:user_append_keyword, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "departed"'
        expect( answer ).to eq( correct )
      end
      it "witout keyword" do
        attribs[:keyword]  = nil
        attribs[:keywords] = nil
        expect { ext_od.send(:user_append_keyword, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :keyword/)
      end

      it "set multi keyword" do
        attribs[:keyword] = ['employee', 'ops', 'it']
        answer  = ext_od.send(:user_set_keyword, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "employee"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "ops"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "it"',
          ]
        expect( answer ).to eq( correct )
      end
      it "set multi-keywords" do
        attribs[:keyword] = nil
        attribs[:keywords] = ['employee', 'ops', 'sis']
        answer  = ext_od.send(:user_set_keywords, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Keywords "employee"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "ops"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -append /Users/someone Keywords "sis"',
          ]
        expect( answer ).to eq( correct )
      end
      it "without keywords" do
        attribs[:keyword]  = nil
        attribs[:keywords] = nil
        expect { ext_od.send(:user_set_keywords, attribs, srv_info) }.
          to raise_error(ArgumentError, /values: 'nil' invalid, value_name: :keywords/)
      end
      it "with keywords empty" do
        attribs[:keyword]  = []
        attribs[:keywords] = nil
        expect { ext_od.send(:user_set_keywords, attribs, srv_info) }.
          to raise_error(ArgumentError, /invalid, value_name: :keywords/)
      end
    end

    describe "Set home_phone" do
      it "with home_phone" do
        answer  = ext_od.send(:user_set_home_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone HomePhoneNumber "024 654 1234"'
        expect( answer ).to eq( correct )
      end
      it "with home_phone_number" do
        attribs[:home_phone]        = nil
        attribs[:home_phone_number] = '024 567 8901'
        answer  = ext_od.send(:user_set_home_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone HomePhoneNumber "024 567 8901"'
        expect( answer ).to eq( correct )
      end
      it "witout home_phone" do
        attribs[:home_phone]        = nil
        attribs[:home_phone_number] = nil
        expect { ext_od.send(:user_set_home_phone, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :home_phone/)
      end
    end

    describe "Set mobile_phone" do
      it "with mobile_phone" do
        answer  = ext_od.send(:user_set_mobile_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MobileNumber "079 678 4321"'
        expect( answer ).to eq( correct )
      end
      it "with mobile_phone_number" do
        attribs[:mobile_phone] = nil
        attribs[:mobile_phone_number] = '079 678 9876'
        answer  = ext_od.send(:user_set_mobile_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MobileNumber "079 678 9876"'
        expect( answer ).to eq( correct )
      end
      it "witout mobile_phone" do
        attribs[:mobile_phone]        = nil
        attribs[:mobile_phone_number] = nil
        expect { ext_od.send(:user_set_mobile_phone, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :mobile_phone/)
      end
    end

    describe "Set work_phone" do
      it "with work_phone" do
        answer  = ext_od.send(:user_set_work_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PhoneNumber "x4890"'
        expect( answer ).to eq( correct )
      end
      it "with work_phone_number" do
        attribs[:work_phone] = nil
        attribs[:work_phone_number] = 'x1234'
        answer  = ext_od.send(:user_set_work_phone, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PhoneNumber "x1234"'
        expect( answer ).to eq( correct )
      end
      it "witout work_phone" do
        attribs[:work_phone]        = nil
        attribs[:work_phone_number] = nil
        expect { ext_od.send(:user_set_work_phone, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :work_phone/)
      end
    end

    describe "Set name_suffix" do
      it "with name_suffix" do
        answer  = ext_od.send(:user_set_name_suffix, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NameSuffix "Jr"'
        expect( answer ).to eq( correct )
      end
      it "with suffix" do
        attribs[:name_suffix] = nil
        attribs[:suffix] = 'Sr'
        answer  = ext_od.send(:user_set_name_suffix, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NameSuffix "Sr"'
        expect( answer ).to eq( correct )
      end
      it "witout name_suffix" do
        attribs[:name_suffix] = nil
        attribs[:suffix]      = nil
        expect { ext_od.send(:user_set_name_suffix, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :name_suffix/)
      end
    end

    describe "Set organization_info" do
      it "with org_info" do
        answer  = ext_od.send(:user_set_organization_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone OrganizationInfo "Top"'
        expect( answer ).to eq( correct )
      end
      it "with organization_info" do
        attribs[:org_info] = nil
        attribs[:organization_info] = 'Down'
        answer  = ext_od.send(:user_set_organization_info, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone OrganizationInfo "Down"'
        expect( answer ).to eq( correct )
      end
      it "without organization_info" do
        attribs[:organization_info] = nil
        attribs[:org_info]          = nil
        expect { ext_od.send(:user_set_organization_info, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :organization_info/)
      end
    end

    describe "Set postal_code" do
      it "with postal_code" do
        answer  = ext_od.send(:user_set_postal_code, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PostalCode "1234"'
        expect( answer ).to eq( correct )
      end
      it "with zip_code" do
        attribs[:postal_code] = nil
        attribs[:zip_code] = '4321'
        answer  = ext_od.send(:user_set_postal_code, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PostalCode "4321"'
        expect( answer ).to eq( correct )
      end
      it "without postal_code" do
        attribs[:postal_code] = nil
        attribs[:zip_code]    = nil
        expect { ext_od.send(:user_set_postal_code, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :postal_code/)
      end
    end

    describe "Set relationships" do
      it "with relationships" do
        answer  = ext_od.send(:user_set_relationships, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Relationships "John"'
        expect( answer ).to eq( correct )
      end
      it "with relations" do
        attribs[:relationships] = nil
        attribs[:relations]     = 'Jane'
        answer  = ext_od.send(:user_set_relationships, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Relationships "Jane"'
        expect( answer ).to eq( correct )
      end
      it "without relationships" do
        attribs[:relationships] = nil
        attribs[:relations]     = nil
        expect { ext_od.send(:user_set_relationships, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :relationships/)
      end
    end

    describe "Set state" do
      it "with state" do
        answer  = ext_od.send(:user_set_state, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone State "Vaud"'
        expect( answer ).to eq( correct )
      end
      it "with state" do
        attribs[:state] = nil
        attribs[:st]    = "Wallis"
        answer  = ext_od.send(:user_set_state, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone State "Wallis"'
        expect( answer ).to eq( correct )
      end
      it "without state" do
        attribs[:state] = nil
        attribs[:st]    = nil
        expect { ext_od.send(:user_set_state, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :state/)
      end
    end

    describe "Set street" do
      it "with street" do
        answer  = ext_od.send(:user_set_street, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Street "chemin de la Source"'
        expect( answer ).to eq( correct )
      end
      it "with address" do
        attribs[:street] = nil
        attribs[:address] = 'Ave Rollier'
        answer  = ext_od.send(:user_set_address, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Street "Ave Rollier"'
        expect( answer ).to eq( correct )
      end
      it "without street" do
        attribs[:street]  = nil
        attribs[:address] = nil
        expect { ext_od.send(:user_set_address, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :street/)
      end
    end

    describe "Set weblog" do
      it "with weblog" do
        answer  = ext_od.send(:user_set_weblog, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone WeblogURI "http://example.ch/weblog"'
        expect( answer ).to eq( correct )
      end
      it "with blog" do
        attribs[:weblog] = nil
        attribs[:blog]   = 'http://example.com/blog'
        answer  = ext_od.send(:user_set_blog, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone WeblogURI "http://example.com/blog"'
        expect( answer ).to eq( correct )
      end
      it "without weblog" do
        attribs[:weblog] = nil
        attribs[:blog]   = nil
        expect { ext_od.send(:user_set_blog, attribs, srv_info) }.
          to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :weblog/)
      end
    end

    describe "Delete Attribute" do
      it "with mobile phone" do
        attribs[:attribute] = 'MobileNumber'
        answer  = ext_od.send(:user_delete_attribute, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone MobileNumber'
        expect(answer).to eq(correct)
      end
    end

  end
end
