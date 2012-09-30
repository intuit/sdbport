require 'json'

module Sdbport
  class Domain
    class Export

      def initialize(args)
        @name       = args[:name]
        @logger     = args[:logger]
        @access_key = args[:access_key]
        @secret_key = args[:secret_key]
        @region     = args[:region]
      end

      def export(output)
        @logger.info "Export #{@name} in #{@region} to #{output}"
        file = File.open(output, 'w')
        export_domain.each do |item| 
          file.write convert_to_string item
          file.write "\n"
        end
        return true if file.close.nil?
      end

      private

      def sdb
        @sdb ||= AWS::SimpleDB.new :access_key => @access_key,
                                   :secret_key => @secret_key,
                                   :region     => @region
      end

      def export_domain
        sdb.select_and_follow_next_token "select * from `#{@name}`"
      end

      def convert_to_string(item)
        item.to_json
      end

    end
  end
end
