require 'trollop'
require 'sdbport/cli/export'
require 'sdbport/cli/import'
require 'sdbport/cli/purge'

module Sdbport
  class CLI

    def start

      cmd = ARGV.shift

      case cmd
      when 'export'
        CLI::Export.new.export
      when 'import'
        CLI::Import.new.import
      when 'purge'
        CLI::Purge.new.purge
      end
    end

  end
end
