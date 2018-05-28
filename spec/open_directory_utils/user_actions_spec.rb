require 'spec_helper'

RSpec.describe OpenDirectoryUtils::UserActions do

  context "build commands" do

    before(:each) do
      # test module without loading real objects
      # https://www.ruby-forum.com/topic/171189
      @od = Object.new
      @od.extend(OpenDirectoryUtils::UserActions)
    end

    describe ":check_uid check errors with bad uid attribute" do
      it "uid = nil" do
        attribs = {uid: nil}
        expect { @od.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /missing uid/)
      end
      it "uid = '' (empty)" do
        attribs = {uid: ''}
        expect { @od.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /blank uid/)
      end
      it "uid = 'with space' (no space allowed)" do
        attribs = {uid: 'with space'}
        expect { @od.send(:check_uid, attribs) }.
            to raise_error(ArgumentError, /uid has space/)
      end
    end

    describe "build actions - fix extra spaces with uid" do
      it "fixes uid with trailing space" do
        attribs = {uid: 'someone '}
        answer  = @od.send(:user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: 'someone  '}
        answer  = @od.send(:user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with leading space" do
        attribs = {uid: ' someone'}
        answer  = @od.send(:user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing spaces" do
        attribs = {uid: '  someone'}
        answer  = @od.send(:user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
      it "fixes uid with trailing and leading spaces" do
        attribs = {uid: '  someone  '}
        answer  = @od.send(:user_get_info, attribs)
        correct = "-read /Users/someone"
        expect( answer ).to eq( correct )
      end
    end

    describe "build od actions w/good data" do
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
      it "user_od_set_real_name" do
        attribs = {uid: 'someone', real_name: "John Doe"}
        answer  = @od.send(:user_od_set_real_name, attribs)
        correct = '-create /Users/someone RealName "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_od_set_unique_id" do
        attribs = {uid: 'someone', unique_id: 987654}
        answer  = @od.send(:user_od_set_unique_id, attribs)
        correct = '-create /Users/someone UniqueID 987654'
        expect( answer ).to eq( correct )
      end
    end

    describe "build ldap actions w/good data" do
      it "user_set_common_name" do
        attribs = {uid: 'someone', cn: "John Doe"}
        answer  = @od.send(:user_set_common_name, attribs)
        correct = '-create /Users/someone cn "John Doe"'
        expect( answer ).to eq( correct )
      end
      it "user_od_set_uidnumber" do
        attribs = {uid: 'someone', uidnumber: 987654}
        answer  = @od.send(:user_set_uidnumber, attribs)
        correct = '-create /Users/someone uidnumber 987654'
        expect( answer ).to eq( correct )
      end
    end

    describe "errors when incorrect/missing data entered" do
      # user_od_set_real_name
      it "for user_od_set_real_name when real_name key missing" do
        attribs = {uid: 'someone'}
        expect { @od.send(:user_od_set_real_name, attribs) }.
            to raise_error(ArgumentError, /real_name/)
      end
      it "for user_od_set_real_name when real_name space" do
        attribs = {uid: 'someone', real_name: " "}
        expect { @od.send(:user_od_set_real_name, attribs) }.
            to raise_error(ArgumentError, /real_name/)
      end
      # user_set_common_name
      it "for user_set_common_name when real_name key missing" do
        attribs = {uid: 'someone'}
        expect { @od.send(:user_set_common_name, attribs) }.
            to raise_error(ArgumentError, /common_name/)
      end
      it "for user_set_common_name when real_name blank" do
        attribs = {uid: 'someone', cn: " "}
        expect { @od.send(:user_set_common_name, attribs) }.
            to raise_error(ArgumentError, /common_name/)
      end
      # user_set_od_unique_id
      it "for user_od_set_unique_id when real_name key missing" do
        attribs = {uid: 'someone'}
        expect { @od.send(:user_od_set_unique_id, attribs) }.
            to raise_error(ArgumentError, /unique_id/)
      end
      it "for user_od_set_unique_id when real_name blank" do
        attribs = {uid: 'someone', unique_id: " "}
        expect { @od.send(:user_od_set_unique_id, attribs) }.
            to raise_error(ArgumentError, /unique_id/)
      end
      # user_set_uidnumber
      it "for user_set_uidnumber when real_name key missing" do
        attribs = {uid: 'someone'}
        expect { @od.send(:user_set_uidnumber, attribs) }.
            to raise_error(ArgumentError, /uidnumber/)
      end
      it "for user_set_uidnumber when real_name blank" do
        attribs = {uid: 'someone', uidnumber: " "}
        expect { @od.send(:user_set_uidnumber, attribs) }.
            to raise_error(ArgumentError, /uidnumber/)
      end
    end

  end
end
