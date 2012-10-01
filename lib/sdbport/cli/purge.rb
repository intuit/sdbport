module Sdbport
  class CLI
    class Purge

      def purge
        opts   = read_options
        logger = SdbportLogger.new :log_level => opts[:level]
        domain = Domain.new :name           => opts[:name],
                            :region         => opts[:region],
                            :access_key     => opts[:access_key],
                            :secret_key     => opts[:secret_key],
                            :logger         => logger
        if opts[:destroy_domain]
          domain.destroy
        else
          domain.purge
        end
      end

      def read_options
        Trollop::options do
          version Sdbport::VERSION
          banner <<-EOS

Purge all entries from a SimpleDB domain.

Usage:

sdbport purge -a xxx -k yyy -r us-west-1 -n domain

EOS
          opt :help, "Display Help"
          opt :destroy_domain "Destroy Domain"
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
