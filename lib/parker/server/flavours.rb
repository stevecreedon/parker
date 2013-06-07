module Parker
  module Server
    module Flavours

      FLAVOURS = [
        "t1.micro",
        "m1.small",
        "m1.medium",
        "m1.large",	
        "m1.xlarge",
        "m3.xlarge",
        "m3.2xlarge",
        "m2.xlarge",
        "m2.2xlarge",
        "m2.4xlarge",
        "c1.medium",
        "c1.xlarge",
        "cc2.8xlarge",
        "cr1.8xlarge",
        "cg1.4xlarge",
        "hi1.4xlarge",
        "hs1.8xlarge"
      ]

      def self.list
        FLAVOURS
      end

      def self.[](index)
        FLAVOURS[index]
      end

    end
  end
end




