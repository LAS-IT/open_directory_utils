require "spec_helper"
require "open_directory_utils/connection"

RSpec.describe OpenDirectoryUtils::Connection do

  context "version available in connection" do
    it "version in module matches" do
      od      = OpenDirectoryUtils::Connection.new
      version = OpenDirectoryUtils::Version::VERSION
      expect( od.version ).to eql( version)
    end
  end

  context "server paramters are correct" do

    # SERVER HOSTNAME
    it "has correct hostname from environment" do
      stub_const('ENV', ENV.to_hash.merge('OD_HOSTNAME' => 'od_hostname'))
      od = OpenDirectoryUtils::Connection.new
      expect(od.srv_info[:hostname]).to eq(ENV['OD_HOSTNAME'])
    end
    it "has correct hostname from parameters" do
      stub_const('ENV', ENV.to_hash.merge('OD_HOSTNAME' => 'od_hostname'))
      od = OpenDirectoryUtils::Connection.new({srv_hostname: 'params_host'})
      expect(od.srv_info[:hostname]).to eq('params_host')
    end

    # SERVER USERNAME
    it "has correct username from environment" do
      stub_const('ENV', ENV.to_hash.merge('OD_USERNAME' => 'od_username'))
      od = OpenDirectoryUtils::Connection.new
      expect(od.srv_info[:username]).to eq(ENV['OD_USERNAME'])
    end
    it "has correct usernzme from parameters" do
      stub_const('ENV', ENV.to_hash.merge('OD_USERNAME' => 'od_username'))
      od = OpenDirectoryUtils::Connection.new({srv_username: 'params_user'})
      expect(od.srv_info[:username]).to eq('params_user')
    end

    # SSH_OPTIONS
    it "has empty default ssh_options" do
      stub_const('ENV', ENV.to_hash.merge('OD_SSH_OPTIONS' => nil))
      od = OpenDirectoryUtils::Connection.new
      expect(od.srv_info[:ssh_options]).to eq({})
    end
    it "ssh_options from ENV VARS overrides defaults" do
      stub_const('ENV', ENV.to_hash.merge('OD_SSH_OPTIONS' => {password: 'secret'}))
      od = OpenDirectoryUtils::Connection.new
      expect(od.srv_info[:ssh_options]).to eq({password: 'secret'})
    end
    it "ssh_options override defaults settings" do
      od = OpenDirectoryUtils::Connection.new({ssh_options: {password: 'ssh_password'}})
      expect(od.srv_info[:ssh_options]).to eq({password: 'ssh_password'})
    end
    it "ssh_options parameters override environment" do
      stub_const('ENV', ENV.to_hash.merge('EQ_SSH_OPTIONS' => '{verify_host_key: false}'))
      od = OpenDirectoryUtils::Connection.new({ssh_options: {password: 'ssh_password'}})
      expect(od.srv_info[:ssh_options]).to eq({password: 'ssh_password'})
    end

    # DIRECTORY DATA PATH / LOCATION
    it "has correct default dir_datapath" do
      stub_const('ENV', ENV.to_hash.merge('DIR_DATAPATH' => nil))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:data_path]).to eq('/LDAPv3/127.0.0.1')
    end
    it "dir_datapath from ENV VARS overrides defaults" do
      stub_const('ENV', ENV.to_hash.merge('DIR_DATAPATH' => '.'))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:data_path]).to eq('.')
    end
    it "dir_datapath override defaults settings" do
      od = OpenDirectoryUtils::Connection.new({dir_datapath: '/LDAPv3/localhost/'})
      expect(od.dir_info[:data_path]).to eq('/LDAPv3/localhost/')
    end
    it "dir_datapath parameters overrides environment" do
      stub_const('ENV', ENV.to_hash.merge('DIR_DATAPATH' => '.'))
      od = OpenDirectoryUtils::Connection.new({dir_datapath: '/LDAPv3/localhost/'})
      expect(od.dir_info[:data_path]).to eq('/LDAPv3/localhost/')
    end

    # DIRECTORY ADMIN USER (Directory read-write)
    it "has nil dir_username by default" do
      stub_const('ENV', ENV.to_hash.merge('DIR_ADMIN_USER' => nil))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:username]).to eq(nil)
    end
    it "has correct dir_username from environment" do
      stub_const('ENV', ENV.to_hash.merge('DIR_ADMIN_USER' => 'dir_username'))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:username]).to eq(ENV['DIR_ADMIN_USER'])
    end
    it "has correct dir_username from parameters" do
      stub_const('ENV', ENV.to_hash.merge('DIR_ADMIN_USER' => 'dir_username'))
      od = OpenDirectoryUtils::Connection.new({dir_username: 'dir_admin'})
      expect(od.dir_info[:username]).to eq('dir_admin')
    end

    # DIRECTORY ADMIN PASSWORD
    it "has nil dir_password by default" do
      stub_const('ENV', ENV.to_hash.merge('DIR_ADMIN_PASS' => nil))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:password]).to eq(nil)
    end
    it "has correct dir_password from environment" do
      stub_const('ENV', ENV.to_hash.merge('DIR_PASSWORD' => 'secret'))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:password]).to eq(ENV['DIR_ADMIN_PASS'])
    end
    it "has correct dir_password from parameters" do
      stub_const('ENV', ENV.to_hash.merge('DIR_ADMIN_PASS' => 'secret'))
      od = OpenDirectoryUtils::Connection.new({dir_password: 'TopSecret'})
      expect(od.dir_info[:password]).to eq('TopSecret')
    end

    # DIRECTORY ADMIN PASSWORD
    it "has correct default dscl command path" do
      stub_const('ENV', ENV.to_hash.merge('DSCL_PATH' => nil))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:dscl]).to eq('/usr/bin/dscl')
    end
    it "dscl command path overrides from ENV VAR" do
      stub_const('ENV', ENV.to_hash.merge('DSCL_PATH' => '/bin/dscl'))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:dscl]).to eq('/bin/dscl')
    end
    it "dscl command path overrides from params" do
      stub_const('ENV', ENV.to_hash.merge('DSCL_PATH' => 'dscl'))
      od = OpenDirectoryUtils::Connection.new({dscl_path: 'dscl'})
      expect(od.dir_info[:dscl]).to eq('dscl')
    end
    it "has correct default pwpolicy command path" do
      stub_const('ENV', ENV.to_hash.merge('PWPOL_PATH' => nil))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:pwpol]).to eq('/usr/bin/pwpolicy')
    end
    it "pwpolicy command path overrides from ENV VAR" do
      stub_const('ENV', ENV.to_hash.merge('PWPOL_PATH' => '/bin/pwpolicy'))
      od = OpenDirectoryUtils::Connection.new
      expect(od.dir_info[:pwpol]).to eq('/bin/pwpolicy')
    end
    it "pwpolicy command path overrides from params" do
      # stub_const('ENV', ENV.to_hash.merge('DPWPOL_PATH' => 'pwpolicy'))
      od = OpenDirectoryUtils::Connection.new({pwpol_path: 'pwpolicy'})
      expect(od.dir_info[:pwpol]).to eq('pwpolicy')
    end
  end

  context "server parameters are not correct" do
    it "errors when srv_hostname is missing" do
      stub_const('ENV', ENV.to_hash.merge('OD_HOSTNAME' => nil))
      expect { OpenDirectoryUtils::Connection.new }.to raise_error(ArgumentError, /server hostname missing/)
    end
    it "errors when srv_username is missing" do
      stub_const('ENV', ENV.to_hash.merge('OD_USERNAME' => nil))
      expect { OpenDirectoryUtils::Connection.new }.to raise_error(ArgumentError, /username missing/)
    end
  end

  # context "correctly builds commands" do
  #   let(:action) { '-append /Users/USERNAME apple-keyword "student"' }
  #   before(:each) do
  #     stub_const('ENV', ENV.to_hash.merge('OD_HOSTNAME'  => 'od_hostname'))
  #     stub_const('ENV', ENV.to_hash.merge('OD_USERNAME'  => 'od_username'))
  #     stub_const('ENV', ENV.to_hash.merge('DIR_USERNAME' => 'diradmin'))
  #     stub_const('ENV', ENV.to_hash.merge('DIR_PASSWORD' => 'TopSecretPass'))
  #     stub_const('ENV', ENV.to_hash.merge('DIR_CMDPATH' => nil))
  #     @od     = OpenDirectoryUtils::Connection.new
  #   end
  # end

  # context "send_cmds_to_od_server via ssh with ONE connection" do
  #   it "returns expected answer with one command" do
  #     od     = OpenDirectoryUtils::Connection.new
  #     action = 'echo "student"'
  #     answer  = od.send(:send_cmds_to_od_server, action)
  #     correct = ['student']
  #     expect(answer).to eq(correct)
  #   end
  #   it "returns expected answers with multiple commands" do
  #     od     = OpenDirectoryUtils::Connection.new
  #     actions = [
  #       'echo "student"',
  #       'echo "departed"',
  #     ]
  #     answer  = od.send(:send_cmds_to_od_server, actions)
  #     correct = [
  #       'student',
  #       'departed',
  #     ]
  #     expect(answer).to eq(correct)
  #   end
  # end

end
