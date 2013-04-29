require_relative 'auto_scale'

ARGV.clear

puts "set capacity for which auto_scale ?"
Parker::AutoScale.list.each_with_index{|flavour, i|  puts "#{i}: #{flavour}"}
index = gets.chomp
group = Parker::AutoScale[index.to_i]

puts group.inspect

group.min_size = @min
group.desired_capacity = @capacity
group.max_size = @max
group.update

