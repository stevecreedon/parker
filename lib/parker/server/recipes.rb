module Parker 
  module Server
    module Recipes  

      RECIPES =  Dir.glob(File.expand_path("../../../recipes/server/*.yaml", __FILE__)).collect do | f |
        { name: f.gsub(".yaml","").gsub("recipes/server/",""), path: f }
      end

      def self.[](i)
        RECIPES[i]
      end

      def self.list
        RECIPES.collect{|r| r[:name]}
      end
    end

  end   
end



