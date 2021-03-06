require 'spec_helper'

klass = OneviewSDK::API300::C7000::UplinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:uplink_data) do
    {
      nativeNetworkUri: nil,
      reachability: 'Reachable',
      manualLoginRedistributionState: 'NotSupported',
      connectionMode: 'Auto',
      lacpTimer: 'Short',
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged',
      description: nil,
      name: UPLINK_SET4_NAME
    }
  end

  let(:log_int) { OneviewSDK::API300::C7000::LogicalInterconnect.get_all($client_300).first }

  describe '#create' do
    it 'can create the uplink and attach to a Logical Interconnect' do
      item = klass.new($client_300, uplink_data)
      item[:logicalInterconnectUri] = log_int[:uri]
      expect { item.create }.not_to raise_error
      expect(item[:uri]).to be
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '#get_unassigned_ports' do
    it 'should return a hash with the unassigned uplink set ports' do
      uplink = klass.new($client_300, name: UPLINK_SET4_NAME)
      expect(uplink.retrieve!).to eq(true)
      ports = uplink.get_unassigned_ports
      expect(ports).not_to be_empty
    end
  end
end
