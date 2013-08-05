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

    def initialize(account)
      self.account = account
      raise "ERROR:  no credentials found in ~/.ss/aws-credentails.yaml for account #{account.inspect}" unless credentials
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

    def cloudwatch
      @cdn ||= Fog::AWS::CloudWatch.new(credentials)
    end

    def credentials
      @credentials ||= _credentials(account)
    end

    private

    def _credentials(account)
      @credential_hash ||= YAML.load_file(ENV['HOME']+'/.ssh/aws-credentials.yaml')
      @credential_hash[account]
    end 

  end
end
