require 'parker/dns/zones'
require 'parker/dns/recordset'

require_relative 'recipes'
require_relative 'flavours'
require_relative 'servers'
require_relative 'user_data'

module Parker
  module Server
    extend self

    def start_or_create recipe_name, count = 1
      count = 1 unless count
      count = 1 if count < 1

      recipe = Parker::Server::Recipes.fetch(recipe_name)
      raise 'No recipe found' unless recipe

      servers = []
      Parker::Servers.servers.select{|server, i| server.state == 'stopped' && server.tags["Name"] == recipe[:name] }.each do | server |
        servers << server
      end

      if servers.size < count
        servers.each do | server |
          server.start
        end

        options = recipe[:server].merge(:tags => {"Name" => recipe[:host]})
        (count - servers.size).times do
          servers << Parker.connection.compute.servers.create(options)
        end
      else
        servers[0,count].each do | server |
          server.start
        end
      end

      servers[0,count].each do | server |
        server.wait_for { print "."; ready? }
      end
    end

    def stop options = {}
      if options[:ip_address]
        server = Parker::Servers.servers.find do |server, i|
          server.state == 'running' &&
          [server.public_ip_address, server.private_ip_address].include?(options[:ip_address])
        end

        server.stop if server
      end
    end

    def start
      puts "Start server"
      stopped_servers = Parker::Servers.servers.select{|server, i| server.state == 'stopped' }
      stopped_servers.each_with_index{|server, i| puts "#{i} #{server.tags['Name']}"}

      server = stopped_servers[gets.chomp.to_i]

      puts "In domain"
      Parker::Dns::Zones.list.each_with_index{|name, i| puts "#{i} #{name}"}
      zone = Parker::Dns::Zones[gets.chomp.to_i]

      server.start
      puts "starting"
      server.wait_for { print "."; ready? }
      puts ""

      Parker::Dns::Recordset.set(zone, server)
    end

    def create recipe_name = nil
      recipe   = Parker::Server::Recipes.fetch(recipe_name) if recipe_name
      recipe ||= Parker::Server::Recipes.ask

      recipe[:server] ||= {}

      zone = Parker::Dns::Zones.fetch recipe[:server][:zone] if recipe[:domain]

      if recipe[:verbose]
        recipe[:server][:flavor_id] = Parker::Server::Flavours.ask  unless recipe[:server][:flavor_id]
        recipe[:host]               = ask_for_host                  unless recipe[:host]

        unless recipe[:domain]
          zone = Parker::Dns::Zones.ask
          recipe[:domain] = zone.domain
        end

        if recipe[:volume]
          recipe[:volume][:size]      = ask_for_storage_size          unless recipe[:volume][:size]
        end

        confirm_settings recipe
      end

      options = recipe[:server].merge(:tags => {"Name" => recipe[:host]})

      puts options.inspect if recipe[:verbose]

      if recipe[:send_user_data].nil? || recipe[:send_user_data]
        puts Parker.user_data("ubuntu_12-10", recipe[:domain], recipe[:host], repo: recipe[:repo]).inspect
        options[:user_data] = Parker.user_data("ubuntu_12-10", recipe[:domain], recipe[:host], repo: recipe[:repo])
      end

      server = Parker.connection.compute.servers.create(options)

      # wait for it to get online
      server.wait_for { print "." if recipe[:verbose]; ready? }
      puts "\n" if recipe[:verbose]

      if recipe[:volume]
        server.volumes.create(recipe[:volume].merge(tags: {"Name" => recipe[:host]}, region: server.availability_zone))
      end

      Parker::Dns::Recordset.set(zone, server) if (recipe[:set_zone].nil? || recipe[:set_zone]) && zone
    end

    def confirm_settings recipe
      puts <<-EOS

Please check your settings:
  recipe       : #{recipe[:name]}
  flavour      : #{recipe[:server][:flavor_id]}
  host         : #{recipe[:host]}
  domain       : #{recipe[:domain]}
  storage size : #{recipe[:volume] ? "#{recipe[:volume][:size]}Gb" : 'no storage' }

      EOS
      puts  "Type 'yes' to continue..."
      confirm = gets.chomp

      exit unless confirm == 'yes'
    end

    def ask_for_host
      puts "Enter host e.g. turbo_seeder"
      host = gets.chomp
    end

    def ask_for_storage_size
      puts "storage in Gb:"
      size = gets.chomp.to_i
    end
  end
end
