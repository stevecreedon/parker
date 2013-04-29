module Parker 
  module AutoScale
    module Recipes
    RECIPES =  Dir.glob("recipes/auto_scale/*.yaml").collect{|f| {name: f.gsub(".yaml","").gsub("recipes/auto_scale/",""), path: f}}

      def self.[](i)
        RECIPES[i]
      end

      def self.list
        RECIPES.collect{|r| r[:name]}
      end

    end 
  end   
end



