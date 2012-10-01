require 'trollop'
require 'sdbport/cli/destroy'
require 'sdbport/cli/export'
require 'sdbport/cli/import'
require 'sdbport/cli/purge'

module Sdbport
  class CLI

    def initialize
      @config = Config.new
      @aws_default_creds = { :access_key => @config.access_key,
                             :secret_key => @config.secret_key }
    end

    def start

      cmd = ARGV.shift

      case cmd
      when 'destroy'
        CLI::Destroy.new(@aws_default_creds).destroy
      when 'export'
        CLI::Export.new(@aws_default_creds).export
      when 'import'
        CLI::Import.new(@aws_default_creds).import
      when 'purge'
        CLI::Purge.new(@aws_default_creds).purge
      when '-v'
        puts Sdbport::VERSION
      else
        puts "Unkown command: '#{cmd}'." unless cmd == '-h'
        puts "sdbport [destroy|export|import|purge] OPTIONS"
        puts "Append -h for help on specific subcommand."
      end
 
    end

  end
end
