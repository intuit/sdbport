require 'trollop'

module Sdbport
  class CLI

    def start
      cmd = ARGV.shift

      @opts = read_options

      options = { :access_key => @opts[:access_key],
                  :secert_key => @opts[:secret_key],
                  :region     => @opts[:region] }

      case cmd
      when 'export'
        @sdbport = AWS::SimpleDB.new options
        puts @sdbport.export
      when 'import'
        @sdbport = AWS::SimpleDB.new options
      end
    end

    private

    def read_options
      Trollop::options do
        version Sdbport::VERSION
        banner <<-EOS

Export simpledb domain.

Usage:

sdbport export --access-key=xxx --secret-key=yyy -r us-west-1

EOS
        opt :help, "Display Help"
        opt :region, "AWS region", :type => :string
        opt :access_key, "AWS Access Key ID", :type => :string,
                                              :short => :none
        opt :secret_key, "AWS Secret Access Key", :type => :string,
                                                  :short => :none
      end
    end
  end
end
