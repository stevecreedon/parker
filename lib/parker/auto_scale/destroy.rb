require_relative 'auto_scale'

ARGV.shift

puts "destroy which auto_scale ?"
Parker::AutoScale.list.each_with_index{|flavour, i|  puts "#{i}: #{flavour}"}
index = gets.chomp
group = Parker::AutoScale[index.to_i]

group.destroy
Parker.connection.auto_scale.configurations.destroy(group.launch_configuration_name)
