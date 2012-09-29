require 'trollop'
require 'sdbport/cli/import'
require 'sdbport/cli/export'

module Sdbport
  class CLI

    def start
      cmd = ARGV.shift

      case cmd
      when 'export'
        CLI::Export.new.export
      when 'import'
        CLI::Import.new.import
      end
    end

  end
end
