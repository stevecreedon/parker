module Parker
  module Server
    module Recipes
      extend self

      def [](i)
        recipes[i]
      end

      def list
        recipes.keys
      end

      def fetch name
        recipes[name.to_sym]
      end

      def ask
        puts "which recipe would you like to use? (type the index number)"
        names = list
        names.each_with_index{|r, i|  puts "#{i}: #{r}"}

        index = gets.chomp

        recipes[names[index.to_i]]
      end

      def recipes
        @recipes ||= begin
          recipes = YAML.load_file(File.expand_path("../../../../recipes/server.yaml", __FILE__))
          recipes.merge!(YAML.load_file(File.expand_path('config/parker.yaml'))) if File.exists?(File.expand_path('config/parker.yaml'))

          recipes
        end
      end
    end
  end
end



