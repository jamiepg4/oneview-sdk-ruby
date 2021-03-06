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

require_relative '../../_client' # Gives access to @client


all_fabrics = OneviewSDK::API300::Synergy::Fabric.find_by(@client, {})

puts "\n\n### Here are all fabrics available:"
all_fabrics.each do |fabric|
  puts fabric['name']
end

fabric2 = OneviewSDK::API300::Synergy::Fabric.new(@client, 'name' => 'DefaultFabric')
puts "\n\n### Retrieving the Fabric named: #{fabric2['name']}"
fabric2.retrieve!
puts JSON.pretty_generate(fabric2.data)

fabric_options = {
  start: 100,
  length: 100,
  type: 'vlan-pool'
}

puts "\n\n### Here we get the reserved vlan range for the first fabric found"
fabric = OneviewSDK::API300::Synergy::Fabric.find_by(@client, {}).first
puts JSON.pretty_generate(fabric.get_reserved_vlan_range)
puts "\n\n### Then we modify the reserved vlan range attributes and get the new values"
fabric.set_reserved_vlan_range(fabric_options)
puts JSON.pretty_generate(fabric.get_reserved_vlan_range)
