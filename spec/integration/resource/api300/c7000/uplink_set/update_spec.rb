require 'spec_helper'

klass = OneviewSDK::API300::C7000::UplinkSet
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  subject(:uplink) { klass.find_by($client_300, name: UPLINK_SET4_NAME).first }
  let(:interconnect) { OneviewSDK::API300::C7000::Interconnect.find_by($client_300, name: INTERCONNECT_2_NAME).first }
  let(:enclosure) { OneviewSDK::API300::C7000::Enclosure.find_by($client_300, name: ENCL_NAME).first }
  let(:network) { OneviewSDK::API300::C7000::EthernetNetwork.get_all($client_300).first }
  let(:port) { interconnect['ports'].select { |item| item['portType'] == 'Uplink' && item['pairedPortName'] }.first }

  before(:all) do
    # Creating it because the #compliance test of logical_interconnect_update removes the uplink before created
    item = klass.from_file($client_300, 'spec/support/fixtures/integration/uplink_set_ethernet.json')
    log_int = OneviewSDK::API300::C7000::LogicalInterconnect.get_all($client_300).first
    item[:logicalInterconnectUri] = log_int[:uri]
    expect { item.create }.not_to raise_error
  end

  describe '#update' do
    it 'update port_config' do
      expect(uplink['portConfigInfos']).to be_empty
      uplink.add_port_config(
        port['uri'],
        'Auto',
        [{ value: port['bayNumber'], type: 'Bay' }, { value: enclosure[:uri], type: 'Enclosure' }, { value: port['portName'], type: 'Port' }]
      )
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['portConfigInfos']).not_to be_empty

      uplink['portConfigInfos'].clear
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['portConfigInfos']).to be_empty
    end

    it 'update network' do
      expect(uplink['networkUris']).to be_empty
      uplink.add_network(network)
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['networkUris']).not_to be_empty

      uplink['networkUris'].clear
      expect { uplink.update }.not_to raise_error
      uplink.refresh
      expect(uplink['networkUris']).to be_empty
    end
  end
end
