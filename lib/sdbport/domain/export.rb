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
        file = File.open(output, 'w')
        export_domain.each do |item| 
          file.write convert_to_string item
          file.write "\n"
        end
        file.close
      end

      private

      def export_domain
        @simpledb.select "select * from #{@name}"
      end

      def convert_to_string(item)
        item.to_json
      end

    end
  end
end
