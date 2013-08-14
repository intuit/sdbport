module Sdbport
  module Cli
    class Run

      def start

        cmd = ARGV.shift

        case cmd
        when 'destroy', 'delete'
          Cli::Destroy.new.destroy
        when 'export'
          Cli::Export.new.export
        when 'import'
          Cli::Import.new.import
        when 'purge'
          Cli::Purge.new.purge
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
end
