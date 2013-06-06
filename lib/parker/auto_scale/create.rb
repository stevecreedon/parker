require_relative 'recipes'

ARGV.shift

puts "which auto scale recipe would you like to use?"
puts "(type the index number)"
Parker::AutoScale::Recipes.list.each_with_index{|r, i|  puts "#{i}: #{r}"}
index = gets.chomp

recipe = YAML.load_file(Parker::AutoScale::Recipes[index.to_i][:path])

configuration = Parker.connection.auto_scale.configurations.create(recipe[:configuration])

group = Parker.connection.auto_scale.groups.create(recipe[:group].merge(launch_configuration_name: configuration.id))

policy = recipe[:scale_up_policy]
Parker.connection.auto_scale.put_scaling_policy(policy[:adjustment_type], 
                                                policy[:group_name], 
                                                "#{policy[:policy_name]}-#{policy[:adjustment]}", 
                                                policy[:adjustment], 
                                                {"Cooldown" => policy[:cooldown]})

scale_up_policy = Parker.connection.auto_scale.policies.get("#{policy[:policy_name]}-#{policy[:adjustment]}")

recipe[:scale_up_alarms].each do |alarm|
  alarm = Parker.connection.cloudwatch.alarm_data.create(alarm.merge(alarm_actions: [scale_up_policy.arn]))
end

policy = recipe[:scale_down_policy]
Parker.connection.auto_scale.put_scaling_policy(policy[:adjustment_type], 
                                                policy[:group_name], 
                                                "#{policy[:policy_name]}-#{policy[:adjustment]}", 
                                                policy[:adjustment], 
                                                {"Cooldown" => policy[:cooldown]})

scale_down_policy = Parker.connection.auto_scale.policies.get("#{policy[:policy_name]}-#{policy[:adjustment]}")

recipe[:scale_down_alarms].each do |alarm|
  alarm = Parker.connection.cloudwatch.alarm_data.create(alarm.merge(alarm_actions: [scale_down_policy.arn]))
end


