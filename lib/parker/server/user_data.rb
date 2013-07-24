module Parker

 def self._load(name)
   load File.join(File.expand_path("../../../../user_data", __FILE__), "#{name}.rb")
 end

 def self.user_data(name, domain, host)
   _load(name)
   ::USER_DATA.gsub("__DOMAIN__", domain).gsub("__HOSTNAME__", host)
 end

end





