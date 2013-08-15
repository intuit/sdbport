module Sdbport
  class Config

    def initialize
      @config = load_config_file
    end

    def access_key(account)
      if @config.has_key? account
        @config[account].fetch 'access_key', nil
      else
        nil
      end
    end

    def secret_key(account)
      if @config.has_key? account
        @config[account].fetch 'secret_key', nil
      else
        nil
      end
    end

    private

    def load_config_file
      config_file = "#{ENV['HOME']}/.sdbport.yml"

      if File.exists? config_file
        YAML::load(File.open(config_file))
      else
        Hash.new
      end
    end

  end
end
