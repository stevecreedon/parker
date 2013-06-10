module Parker
  module Dns
    module Zones
      extend self
  
      @@zones = nil

      def zones
        @@zones ||= Parker.connection.dns.zones
      end

      def [](index)
        zones[index]
      end

      def list
        zones.collect{|zone, i| zone.domain }
      end

      def fetch name
        zones.find { | zone | zone.domain == name }
      end

      def ask
        puts "Enter domain"
        list.each_with_index{|name, i| puts "#{i} #{name}"}

        self[gets.chomp.to_i]
      end

    end
  end
end
