module Parker
  module Dns
    module Zones
  
      @@zones = nil

      def self.zones
        @@zones ||= _zones
      end

      def self.[](index)
        zones[index]
      end

      def self.list
        zones.collect{|zone, i| zone.domain }
      end

      private

      def self._zones
        Parker.connection.dns.zones
      end

    end
  end
end
