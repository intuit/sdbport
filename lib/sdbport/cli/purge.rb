module Sdbport
  class CLI
    class Purge

      def purge
        opts   = read_options
        logger = SdbportLogger.new
        domain = Domain.new :name       => opts[:name],
                            :region     => opts[:region],
                            :access_key => opts[:access_key],
                            :secret_key => opts[:secret_key],
                            :logger     => logger
        domain.purge
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
          opt :name, "Simple DB Domain Name", :type => :string
          opt :region, "AWS region", :type => :string
          opt :access_key, "AWS Access Key ID", :type => :string
          opt :secret_key, "AWS Secret Access Key", :type => :string
        end
      end
    end
  end
end
