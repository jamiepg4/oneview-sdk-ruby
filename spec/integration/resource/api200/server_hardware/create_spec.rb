require 'spec_helper'

klass = OneviewSDK::ServerHardware
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#add' do
    it 'can create resources' do
      options = {
        hostname: $secrets['server_hardware_ip'],
        username: $secrets['server_hardware_username'],
        password: $secrets['server_hardware_password'],
        name: 'test',
        licensingIntent: 'OneView'
      }

      item = OneviewSDK::ServerHardware.new($client, options)
      expect { item.add }.to_not raise_error
    end
  end

  describe '#get_bios' do
    it 'Get list of bios\UEFI values' do
      item = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      expect { item.get_bios }.not_to raise_error
    end
  end

  describe '#get_ilo_sso_url' do
    it 'Get a url to the iLO web interface' do
      item = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      expect { item.get_ilo_sso_url }.not_to raise_error
    end
  end

  describe '#get_java_remote_sso_url' do
    it 'Single Sign-On session for the Java Applet console' do
      item = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      expect { item.get_java_remote_sso_url }.not_to raise_error
    end
  end

  describe '#get_remote_console_url' do
    it 'Get a url to the iLO web interface' do
      item = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      expect { item.get_remote_console_url }.not_to raise_error
    end
  end

  describe '#environmental_configuration' do
    it 'Gets the script' do
      item = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      expect { item.environmental_configuration }.not_to raise_error
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      item = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
      expect { item.utilization }.not_to raise_error
    end
  end

end
