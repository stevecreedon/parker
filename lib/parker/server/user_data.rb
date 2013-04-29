module Parker

 def self.load(name)
   file = File.open(File.join("user_data", name),"r")
   file.gets
 end

 def self.user_data(name, domain, host)
   load(name).gsub("__DOMAIN__", domain).gsub("__HOSTNAME__", host)
 end

end





