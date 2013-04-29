module Parker 
  module Server
    module Recipes  
    RECIPES =  Dir.glob("recipes/server/*.yaml").collect{|f| {name: f.gsub(".yaml","").gsub("recipes/server/",""), path: f}}

      def self.[](i)
        RECIPES[i]
      end

      def self.list
        RECIPES.collect{|r| r[:name]}
      end
    end

  end   
end



