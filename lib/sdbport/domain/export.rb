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
        file = setup_file output
        export_domain.each do |item| 
          file.write convert_to_string item
          file.write "\n"
        end
        return true if file.close.nil?
      end

      def export_sequential_write(output)
        file = setup_file output
        @logger.info "Writing to disk as records received."

        while true
          export_domain_with_sequential_write.each do |item| 
            file.write convert_to_string item
            file.write "\n"
          end
          break unless sdb.more_chunks?
        end
        return true if file.close.nil?
      end

      private

      def setup_file(output)
        @logger.info "Export #{@name} in #{@region} to #{output}"
        File.open(output, 'w')
      end

      def sdb
        @sdb ||= AWS::SimpleDB.new :access_key => @access_key,
                                   :secret_key => @secret_key,
                                   :region     => @region
      end

      def export_domain
        sdb.select_and_follow_tokens "select * from `#{@name}`"
      end

      def export_domain_with_sequential_write
        sdb.select_and_store_chunk_of_tokens "select * from `#{@name}`"
      end

      def convert_to_string(item)
        id         = item.first
        attributes = format_attributes item.last

        [id, attributes].to_json
      end

      # Converts nil values to empty strings
      def format_attributes(data)
        data.each do |k, v|
          data[k] = v.map { |x| x.nil? ? "" : x }
        end

        data
      end

    end
  end
end
