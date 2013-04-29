require 'rubygems'
require 'fog'
require 'configatron'

require_relative 'connection'
require_relative 'zones'
require_relative 'servers'

Parker.connect! ARGV.pop

Parker.connection.cdn.distributions.get("E2JAHU2UDUVTR7").invalidations.create(:paths => ["/"])
