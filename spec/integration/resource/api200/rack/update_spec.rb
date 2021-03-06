# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'spec_helper'

RSpec.describe OneviewSDK::Rack, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#update' do
    it 'updates depth' do
      item = OneviewSDK::Rack.new($client, name: RACK1_NAME)
      item.retrieve!
      item.update(depth: 1300)
      expect(item['depth']).to eq(1300)
    end
  end
end
