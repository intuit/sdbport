module Sdbport
  class Config

    attr_accessor :access_key, :secret_key

    def initialize(args = {})
      @config = load_config_file
      @access_key = @config.fetch 'access_key', nil
      @secret_key = @config.fetch 'secret_key', nil
    end

    def load_config_file
      config_file = "#{ENV['HOME']}/.sdbport.yml"

      if File.exists? config_file
        YAML::load File.open(config_file)
      else
        Hash.new
      end
    end

  end
end
