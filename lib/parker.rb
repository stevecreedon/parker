$:.push File.expand_path("../", __FILE__)
$:.push File.expand_path("../../", __FILE__)

require "parker/version"

require 'parker/connection'
require 'parker/tasks'


module Parker
  extend self

  def root
    @root_path ||= File.expand_path('../', File.dirname(__FILE__))
  end

end
