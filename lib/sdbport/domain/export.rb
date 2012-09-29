require 'json'

module Sdbport
  class Domain
    class Export

      def initialize(args)
        @name     = args[:name]
        @logger   = args[:logger]
        @region   = args[:region]
        @simpledb = AWS::SimpleDB.new args
      end

      def export(output)
        @logger.info "Export #{@name} in #{@region} to #{output}"
        items = @simpledb.select "select * from #{@name}"
        file = File.open(output, 'w')
        items.each do |item| 
          file.write convert_to_string(item) 
          file.write "\n"
        end
      end

      private

      def convert_to_string(item)
        item.to_json
      end
    end

  end
end
