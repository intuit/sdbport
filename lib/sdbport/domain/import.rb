require 'json'

module Sdbport
  class Domain
    class Import

      def initialize(args)
        @name     = args[:name]
        @logger   = args[:logger]
        @region   = args[:region]
        @simpledb = AWS::SimpleDB.new args
      end

      def import(input)
        @logger.info "Importing #{@name} in #{@region} from #{input}".
        file = File.open(input, 'r')
        while (line = file.gets)
          data = JSON.parse line.chomp
          id = data.first
          attributes = data.last
          puts "id: #{id}"
          puts "attributes: #{attributes}"
        end
        file.close
      end

    end
  end
end
