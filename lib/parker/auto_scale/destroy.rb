require_relative 'auto_scale'

def destroy(name, resource)
  Parker.connection.auto_scale.send(resource).destroy(name) if Parker.connection.auto_scale.send(resource).get(name)  
end

ARGV.shift

puts "destroy which auto_scale ?"
Parker::AutoScale.list.each_with_index{|flavour, i|  puts "#{i}: #{flavour}"}
index = gets.chomp
name = Parker::AutoScale[index.to_i].id

destroy(name, :groups)
destroy(name, :configurations)

#con.groups.destroy(name) unless con.groups.get(id).empty?

#Parker.connection.auto_scale.configurations.destroy(group.launch_configuration_name)
