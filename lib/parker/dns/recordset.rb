module Parker
  module Dns
    module Recordset

      def self.set(zone, server)
        zone.records.each do |record|
          if record.name =~ Regexp.compile("#{server.tags["Name"]}\.")
            record.modify(value: [server.dns_name])
            return
          end
        end

        zone.records.create(
          :value   => server.dns_name,
          :name => "#{server.tags['Name']}.#{zone.domain}",
          :type => 'CNAME'
        )
      end

    end
  end
end
