require_relative '../dns/zones'
require_relative '../dns/recordset'
require_relative 'servers'

ARGV.shift

puts "Start server"
Parker::Servers.list.each_with_index{|name, i| puts "#{i} #{name}"}
server = Parker::Servers[gets.chomp.to_i]


puts "In domain"
Parker::Dns::Zones.list.each_with_index{|name, i| puts "#{i} #{name}"}
zone = Parker::Dns::Zones[gets.chomp.to_i]


server.start
puts "starting"
server.wait_for { print "."; ready? }
#puts server.inspect
#puts zone.records.inspect

Parker::Dns::Recordset.set(zone, server)


