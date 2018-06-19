require 'spec_helper'
require "open_directory_utils/commands_user_create_remove"

RSpec.describe OpenDirectoryUtils::CommandsUserCreateRemove do

  context "build commands" do

    let(:user)     { Object.new.extend(OpenDirectoryUtils::CommandsUserCreateRemove) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy',
                      dsedit: '/usr/sbin/dseditgroup'} }

    describe "user_delete" do
      it "with uid" do
        attribs = {uid: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with username" do
        attribs = {username: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with shortname" do
        attribs = {user_name: 'someone'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra attribute" do
        attribs = {user_name: 'someone', attribute: 'nothing'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
      it "with extra value" do
        attribs = {user_name: 'someone', value: 'nothing'}
        answer  = user.send(:user_delete, attribs, srv_info)
        correct = '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -delete /Users/someone'
        expect( answer ).to eq( correct )
      end
    end

    describe "user_create_min" do
      let(:correct) {
        [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "12345"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "9876"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
      }
      it "with needed uid" do
        attribs = { uid: 'someone', uidnumber: '12345', gidnumber: '9876' }
        answer  = user.send(:user_create_min, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with needed username" do
        attribs = { username: 'someone', uidnumber: '12345', gidnumber: '9876'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with needed shortname" do
        attribs = { user_name: 'someone', uidnumber: '12345', gidnumber: '9876'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with all enable: true" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: true}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all enable: true" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: 'true'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all enable: false" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: false}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all enable: 'junk'" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543', enable: 'junk'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with all realname" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with first & last name" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'Special', uniqueid: '9876543'}
        answer  = user.send(:user_create_min, attribs, srv_info)
        correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone Special"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( correct )
      end
      it "with extra attributes - no uid" do
        attribs = { email: 'user@example.com', gidnumber: '1032',
                    real_name: 'Someone Special', uniqueid: '9876543'}
        expect { user.send(:user_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with missing shortname" do
        attribs = { }
        expect { user.send(:user_create_min, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
    end

    describe "user_create" do
      let(:correct) {[
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone SPECIAL"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
        '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
        '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
        # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"'
      ]}
      it "with minimal attributes" do
        attribs = { uid: 'someone', gidnumber: '1032', uniqueid: '9876543' }
        answer  = user.send(:user_create, attribs, srv_info)
        min_correct = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
        ]
        expect( answer ).to eq( min_correct )
      end
      it "with real_name attributes" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: "SPECIAL", uniqueid: '9876543',
                    real_name: 'Someone SPECIAL' }
        answer  = user.send(:user_create, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with first & last name attributes" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        answer  = user.send(:user_create, attribs, srv_info)
        expect( answer ).to eq( correct )
      end
      it "with all possible fields" do
        attribs  = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543',
                    group_membership: 'testgrp', password: 'TopSecret', enable: true,
                    relationships: '87654', organization_info: '45678',
                  }
        answer   = user.send(:user_create, attribs, srv_info)
        with_all = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "TopSecret"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Relationships "87654"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone OrganizationInfo "45678"',
          '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user testgrp',
        ]
        expect( answer ).to eq( with_all )
      end
      it "without email" do
        attribs  = {uid: 'someone', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        answer   = user.send(:user_create, attribs, srv_info)
        no_email = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
        ]
        expect(answer).to eq( no_email )
      end
      it "with missing attributes (no firstname)" do
        attribs  = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    last_name: 'SPECIAL', uniqueid: '9876543'}
        answer   = user.send(:user_create, attribs, srv_info)
        no_first = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "*"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"',
        ]
        expect(answer).to eq( no_first )
      end
      it "with missing attributes (no lastname)" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', uniqueid: '9876543', password: 'TopSecret'}
        answer  = user.send(:user_create, attribs, srv_info)
        no_last = [
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "TopSecret"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/bash"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -disableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone apple-user-mailattribute "user@example.com"',
        ]
        expect(answer).to eq( no_last )
      end
      it "with missing attributes (no username)" do
        attribs = { email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        expect { user.send(:user_create, attribs, srv_info) }.
            to raise_error(ArgumentError, /record_name: 'nil' invalid/)
      end
      it "with missing attributes (no PrimaryGroupID)" do
        attribs = { uid: 'someone', email: 'user@example.com',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543'}
        expect { user.send(:user_create, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :group_id/)
      end
      it "with missing attributes (no uniqueid)" do
        attribs = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL'}
        expect { user.send(:user_create, attribs, srv_info) }.
            to raise_error(ArgumentError, /value: 'nil' invalid, value_name: :unique_id/)
      end
    end

    context "update user" do
      it "with all possible fields" do
        attribs  = { uid: 'someone', email: 'user@example.com', gidnumber: '1032',
                    first_name: 'Someone', last_name: 'SPECIAL', uniqueid: '9876543',
                    group_membership: 'testgrp', password: 'TopSecret', enable: true,
                    relationships: '87654', organization_info: '45678',
                    shell: '/bin/false',
                  }
        answer   = user.send(:user_update, attribs, srv_info)
        with_all = [
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -passwd /Users/someone "TopSecret"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UserShell "/bin/false"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone LastName "SPECIAL"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone RealName "Someone SPECIAL"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone UniqueID "9876543"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone PrimaryGroupID "1032"',
          # '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone NFSHomeDirectory "/Volumes/Macintosh HD/Users/someone"',
          # '/usr/bin/pwpolicy -a diradmin -p "TopSecret" -n /LDAPv3/127.0.0.1 -u someone -enableuser',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone FirstName "Someone"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone MailAttribute "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone EMailAddress "user@example.com"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone Relationships "87654"',
          '/usr/bin/dscl -u diradmin -P "TopSecret" /LDAPv3/127.0.0.1 -create /Users/someone OrganizationInfo "45678"',
          '/usr/sbin/dseditgroup -o edit -u diradmin -P "TopSecret" -n /LDAPv3/127.0.0.1 -a someone -t user testgrp',
        ]
        expect( answer ).to eq( with_all )
      end
    end

  end
end
