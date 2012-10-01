module Sdbport
  class CLI
    class Destroy

      def initialize(args)
        @default_access_key = args[:access_key]
        @default_secret_key = args[:secret_key]
      end

      def destroy
        opts       = read_options
        access_key = opts[:access_key] || @default_access_key
        secret_key = opts[:secret_key] || @default_secret_key

        logger = SdbportLogger.new :log_level => opts[:level]
        domain = Domain.new :name       => opts[:name],
                            :region     => opts[:region],
                            :access_key => access_key,
                            :secret_key => secret_key,
                            :logger     => logger
        exit 1 unless domain.destroy
      end

      def read_options
        Trollop::options do
          version Sdbport::VERSION
          banner <<-EOS

Destroy SimpleDB Domain

Usage:

sdbport destroy -a xxx -k yyy -r us-west-1 -n domain

EOS
          opt :help, "Display Help"
          opt :level, "Log Level", :type => :string, :default => 'info'
          opt :name, "Simple DB Domain Name", :type => :string
          opt :region, "AWS region", :type => :string
          opt :access_key, "AWS Access Key ID", :type => :string
          opt :secret_key, "AWS Secret Access Key", :type => :string
        end
      end
    end
  end
end
