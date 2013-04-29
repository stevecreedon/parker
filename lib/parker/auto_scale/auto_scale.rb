module Parker
  module AutoScale

    @@auto_scale = nil

    def self.auto_scale
      @@auto_scale ||= _auto_scale
    end

    def self.[](index)
      auto_scale[index]
    end

    def self.list
      auto_scale.collect{|as, i| as.id }
    end

    private

    def self._auto_scale
      Parker.connection.auto_scale.groups
    end
    
  end
end
