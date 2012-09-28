require 'trollop'

module Sdbport
  module CLI
    def self.start
      cmd = ARGV.shift

      case cmd
      when 'export'
        puts 'export'
      when 'import'
        puts 'import'
      end
    end
  end
end
