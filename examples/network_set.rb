require_relative '_client' # Gives access to @client

# Example: Create a network set
# NOTE: This will create a network set named 'NetworkSet_1', then delete it.

# Retrieve ethernet networks available in HPE OneView
ethernet_networks = OneviewSDK::EthernetNetwork.find_by(@client, {})

# Network set creation
network_set = OneviewSDK::NetworkSet.new(@client)
network_set['name'] = 'NetworkSet_1'

# Adding until three ethernet networks to the network set
ethernet_networks.each_with_index { |ethernet, index| network_set.add_ethernet_network(ethernet) if index < 4 }

# Set first ethernet network as native network for network set
network_set.set_native_network(ethernet_networks.first) if ethernet_networks.size > 0

# Network set creation
network_set.create
puts "\nThe network set with name='#{network_set['name']}' and uri='#{network_set['uri']}' was created!\n"
puts "- nativeNetworkUri='#{network_set['nativeNetworkUri']}'"
network_set['networkUris'].each { |network| puts "- networkUri='#{network}'" }

# Deletes network set
network_set.delete
puts "\nThe network set with name='#{network_set['name']}' and uri='#{network_set['uri']}' was deleted!\n"