require 'rake'

namespace :parker do

  namespace :servers do

    desc "lists servers for the supplied [account]"
    task :list, [:account] do |t, args|
      Parker.connect! args[:account]
      puts Parker.connection.compute.servers.inspect
    end

    desc "starts servers for the supplied [account]"
    task :start, [:account] do |t, args|
      Parker.connect! args[:account]
      require_relative 'server/start'
    end

    desc "creates a new server for the supplied [account]"
    task :create, [:account] do |t, args|
      Parker.connect! args[:account]
      require_relative 'server/create'
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
