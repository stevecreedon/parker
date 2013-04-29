require 'rubygems'
require 'fog'

require_relative 'connection'
require_relative 'zones'

Parker.connect! ARGV.pop
puts Parker.connection.compute.servers.inspect
 
puts fog.volumes.inspect

# instance id -> find it again
puts fog.security_groups.inspect

puts fog.servers.last.volumes.inspect

zone = dns.zones.find do |zone|
   zone.domain == 'xaza.co.uk.'
end

puts x.inspect

# shutdown
#server.destroy





