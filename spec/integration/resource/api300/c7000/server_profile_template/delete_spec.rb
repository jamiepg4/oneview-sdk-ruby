require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerProfileTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  let(:names) { [SERVER_PROFILE_TEMPLATE_NAME] }

  describe '#delete' do
    it 'deletes the associated Server profiles' do
      names.each do |name|
        item = OneviewSDK::API300::C7000::ServerProfileTemplate.find_by($client_300, 'name' => name).first
        spts = OneviewSDK::API300::C7000::ServerProfile.find_by($client_300, 'serverProfileTemplateUri' => item['uri'])
        spts.each do |spt|
          expect { spt.delete }.to_not raise_error
        end
      end
    end

    it 'deletes all the resources' do
      names.each do |name|
        item = OneviewSDK::API300::C7000::ServerProfileTemplate.find_by($client_300, 'name' => name).first
        expect(item).to be
        expect { item.delete }.to_not raise_error
      end
    end
  end
end
