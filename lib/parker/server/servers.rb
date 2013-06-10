module Parker
  module Servers
    extend self

    @@servers = nil

    def servers
      @@servers ||= Parker.connection.compute.servers
    end

    def [](index)
      servers[index]
    end

    def list
      servers.collect{|server, i| server.tags["Name"] }
    end

  end
end


