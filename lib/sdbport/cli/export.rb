module Sdbport
  class CLI
    class Export

      def initialize
        @config = Config.new
      end

      def export
        opts       = read_options
        access_key = @config.access_key opts[:account]
        secret_key = @config.secret_key opts[:account]
        access_key = opts[:access_key] if opts[:access_key] 
        secret_key = opts[:secret_key] if opts[:secret_key]

        logger = SdbportLogger.new :log_level => opts[:level]
        domain = Domain.new :name       => opts[:name],
                            :region     => opts[:region],
                            :access_key => access_key,
                            :secret_key => secret_key,
                            :logger     => logger

        if opts[:write_as_you_go]
          exit 1 unless domain.export_sequential_write opts[:output]
        else
          exit 1 unless domain.export opts[:output]
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
          opt :account, "Account Credentials", :type    => :string,
                                               :default => 'default'
          opt :level, "Log Level", :type => :string, :default => 'info'
          opt :name, "Simple DB Domain Name", :type => :string
          opt :output, "Output File", :type => :string
          opt :region, "AWS Region", :type => :string
          opt :access_key, "AWS Access Key ID", :type  => :string,
                                                :short => 'k'
          opt :secret_key, "AWS Secret Access Key", :type => :string
          opt :write_as_you_go, "Write chunks as they are received from Simple DB", :type => :string
        end
      end
    end
  end
end
