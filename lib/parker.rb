$:.push File.expand_path("../", __FILE__)
$:.push File.expand_path("../../", __FILE__)

require "parker/version"

require 'parker/connection'
require 'parker/tasks'


module Parker
  extend self

  def root
    File.expand_path('../', __FILE__)
  end

end
