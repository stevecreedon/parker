require_relative 'user_data'
require_relative 'flavours'
require_relative 'recipes'
require_relative '../dns/zones'

ARGV.shift

#RECIPES
puts "which recipe would you like to use?"
puts "(type the index number)"
Parker::Server::Recipes.list.each_with_index{|r, i|  puts "#{i}: #{r}"}
index = gets.chomp
recipe = YAML.load_file(Parker::Server::Recipes[index.to_i][:path])

#FLAVORS
puts "which flavour do you fancy ?"
Parker::Server::Flavours.list.each_with_index{|flavour, i|  puts "#{i}: #{flavour}"}
index = gets.chomp
flavour = Parker::Server::Flavours[index.to_i]

puts "Enter host e.g. turbo_seeder"
host = gets.chomp

puts "Enter domain"
Parker::Dns::Zones.list.each_with_index{|name, i| puts "#{i} #{name}"}
zone = Parker::Dns::Zones[gets.chomp.to_i]

puts "storage in Gb:"
size = gets.chomp.to_i

puts "recipe: #{recipe[:name]}, flavour: #{flavour}, host: #{host}, domain: #{zone.domain}, #{size}Gb of Storage."
puts  "Type 'yes' to continue..."
confirm = gets.chomp

#return unless confirm == 'yes'

server = Parker.connection.compute.servers.create(recipe[:server].merge(:user_data => Parker.user_data("ubuntu_12-10", zone.domain, host), 
                                                                        :tags => {"Name" => host}, 
                                                                        :flavor_id=> flavour))

# wait for it to get online
server.wait_for { print "."; ready? }

server.volumes.create(recipe[:volume].merge(tags: {"Name" => host}, size: size, region: server.availability_zone))

zone.records.create(
  :value   => server.dns_name,
  :name => "#{host}.#{zone.domain}",
  :type => 'CNAME'
)




