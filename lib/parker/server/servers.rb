module Parker
  module Servers

    @@servers = nil

    def self.servers
      @@servers ||= _servers
    end

    def self.[](index)
      servers[index]
    end

    def self.list
      servers.collect{|server, i| server.tags["Name"] }
    end

    private

    def self._servers
      Parker.connection.compute.servers
    end

  end
end


