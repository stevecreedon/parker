require_relative 'recipes'

ARGV.shift

puts "which auto scale recipe would you like to use?"
puts "(type the index number)"
Parker::AutoScale::Recipes.list.each_with_index{|r, i|  puts "#{i}: #{r}"}
index = gets.chomp

recipe = YAML.load_file(Parker::AutoScale::Recipes[index.to_i][:path])

configuration = Parker.connection.auto_scale.configurations.create(recipe[:configuration])

Parker.connection.auto_scale.groups.create(recipe[:group].merge(launch_configuration_name: configuration.id))


