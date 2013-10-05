require 'erb'

module Parker
 
 def self.user_data(name, domain, host, options)
   user_data = ::ERB.new(File.new(File.join("user_data", "#{name}.rb.erb")).read)
   user_data.result(binding)
 end

end





