module Sdbport
  class CLI
    class Export

      def export
        @config = Config.new
        opts    = read_options
        logger  = SdbportLogger.new :log_level => opts[:level]
        domain  = Domain.new :name       => opts[:name],
                            :region     => opts[:region],
                            :access_key => opts[:access_key],
                            :secret_key => opts[:secret_key],
                            :logger     => logger
        unless domain.export opts[:output]
          exit 1
        end
      end

      def read_options
        Trollop::options do
          version Sdbport::VERSION
          banner <<-EOS

Export SimpleDB domain.

Usage:

sdbport export -a xxx -k yyy -r us-west-1 -o /tmp/file -n domain

EOS
          opt :help, "Display Help"
          opt :level, "Log Level", :type => :string, :default => 'info'
          opt :name, "Simple DB Domain Name", :type => :string
          opt :output, "Output File", :type => :string
          opt :region, "AWS region", :type => :string
          opt :access_key, "AWS Access Key ID", :type    => :string,
                                                :default => @config.access_key
          opt :secret_key, "AWS Secret Access Key", :type    => :string,
                                                    :default => @config.secret_key
        end
      end
    end
  end
end
