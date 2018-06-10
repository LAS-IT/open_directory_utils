require 'spec_helper'
require "open_directory_utils/commands_user_attribs_extended"

RSpec.describe OpenDirectoryUtils::CommandsUserAttribsExtended do

  context "build commands for syncing extended user attributes" do

    let(:user)     { Object.new.extend(OpenDirectoryUtils::CommandsUserAttribsExtended) }
    let(:srv_info) { {username: 'diradmin', password: 'TopSecret',
                      data_path: '/LDAPv3/127.0.0.1',
                      dscl: '/usr/bin/dscl',
                      pwpol: '/usr/bin/pwpolicy',
                      dsedit: '/usr/sbin/dseditgroup'} }

    describe "sync" do
      it "some field" do
      end
    end

  end
end
