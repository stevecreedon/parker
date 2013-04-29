require 'fog'

module Parker

  @@conn = nil

  def self.connection
    @@conn
  end

  def self.connect!(account)
    @@conn = Connection.new(account)
  end

  class Connection
    attr_accessor :account

    CREDENTIALS = YAML.load_file(ENV['HOME']+'/.ssh/aws-credentials.yaml')

    def initialize(account)
      raise "ERROR:  no credentials found in ~/.ss/aws-credentails.yaml for account #{account.inspect}" unless CREDENTIALS[account]
      self.account = account  
    end

    def compute
      @compute ||= Fog::Compute.new({provider: 'AWS'}.merge(credentials))
    end

    def dns
      @dns ||= Fog::DNS.new({provider: 'AWS'}.merge(credentials))
    end

    def auto_scale
      @as ||= Fog::AWS::AutoScaling.new(credentials)
    end

    def cdn
      @cdn ||= Fog::CDN.new({provider: 'AWS'}.merge(credentials))
    end

    def credentials
      @credentials ||= _credentials(account)
    end

    private

    def _credentials(account)
      CREDENTIALS[account]
    end 

  end
end
