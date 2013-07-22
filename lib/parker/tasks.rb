require 'rake'

namespace :parker do

  namespace :servers do

    desc 'creates image'
    task :create_image, [:account, :instance_id, :name, :description] do | t, args |
      raise 'No account given'     unless args[:account]
      raise 'No instance_id given' unless args[:instance_id]
      raise 'No name given'        unless args[:name]
      raise 'No description given' unless args[:description]

      Parker.connect! args[:account]

      Parker.connection.compute.create_image(args[:instance_id], args[:name], args[:description])
    end

    desc "lists servers for the supplied [account]"
    task :list, [:account] do |t, args|
      Parker.connect! args[:account]
      puts Parker.connection.compute.servers.inspect
    end

    desc "stops server by ip_address"
    task :stop_with_ip_address, [:account, :ip_address] do |t, args|
      raise 'No account given' unless args[:account]
      raise 'No ip_address given' unless args[:ip_address]

      Parker.connect! args[:account]

      ARGV.shift

      require 'parker/server/server'
      Parker::Server.stop ip_address: args[:ip_address]
    end

    desc "starts/creates server for the supplied [account] and [recipe]"
    task :start_or_create, [:account, :recipe, :count] do |t, args|
      raise 'No account given' unless args[:account]
      raise 'No recipe given' unless args[:recipe]

      Parker.connect! args[:account]

      ARGV.shift

      require 'parker/server/server'
      Parker::Server.start_or_create args[:recipe], args[:count].to_i
    end

    desc "starts servers for the supplied [account]"
    task :start, [:account] do |t, args|
      Parker.connect! args[:account]

      ARGV.shift

      require 'parker/server/server'
      Parker::Server.start
    end

    desc "creates a new server for the supplied [account] and recipe (optional)"
    task :create, [ :account, :recipe ] do |t, args|
      Parker.connect! args[:account]

      ARGV.shift

      require 'parker/server/server'
      Parker::Server.create args[:recipe]
    end

  end

  namespace :auto_scale do

    desc "list the existing auto scale groups"
    task :list, [:account] do |t, args|
      Parker.connect! args[:account]
      require_relative 'auto_scale/auto_scale'
      puts Parker::AutoScale.list.inspect
    end

    desc "list the existing auto scale groups"
    task :inspect, [:account] do |t, args|
      Parker.connect! args[:account]
      puts "Groups:"
      puts Parker.connection.auto_scale.groups.inspect
      puts "Configurations:"
      puts Parker.connection.auto_scale.configurations.inspect
      puts "Policies:"
      Parker.connection.auto_scale.policies.each do |policy|
        puts policy.inspect
      end
    end

    desc "create the autoscale group with the specified [account]"
    task :create, [:account] do |t, args|
      Parker.connect! args[:account]
      require_relative 'auto_scale/create'
    end

    desc "destroy the autoscale group with the specified [account]"
    task :destroy, [:account] do |t, args|
      Parker.connect! args[:account]
      require_relative 'auto_scale/destroy'
    end

    desc "set the auto scale instance capacity with[account, min, capacity, max]"
    task :set_capacity, [:account, :min, :capacity, :max] do |t, args|
      Parker.connect! args[:account]
      @capacity = args[:capacity].to_i
      @max = args[:max].to_i
      @min = args[:min].to_i
      require_relative 'auto_scale/set_capacity'
    end

  end

end
