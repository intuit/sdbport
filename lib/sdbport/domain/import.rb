require 'json'

module Sdbport
  class Domain
    class Import

      def initialize(args)
        @name       = args[:name]
        @logger     = args[:logger]
        @access_key = args[:access_key]
        @secret_key = args[:secret_key]
        @region     = args[:region]
        @buffer     = {}
      end

      def import(input)
        create_domain

        return false unless ensure_domain_empty

        @logger.info "Importing #{@name} in #{@region} from #{input}."

        file = File.open(input, 'r')
        while (line = file.gets)
          add_line_to_buffer line
          write_buffer if @buffer.count == 25
        end
        write_buffer
        true
      end

      private

      def create_domain
        sdb.create_domain_unless_present @name
      end

      def write_buffer
        @logger.debug "Writing #{@buffer.count} entries to SimpleDB."
        sdb.batch_put_attributes @name, @buffer
        @buffer.clear
      end

      def add_line_to_buffer(line)
        line.chomp!
        data       = JSON.parse line
        id         = data.first
        attributes = data.last

        @logger.debug "Adding #{id} with attributes #{attributes.to_s}."
        @buffer.merge!({ id => attributes })
      end

      def ensure_domain_empty
        if sdb.domain_empty? @name
          true
        else
          @logger.error "Domain #{@name} in #{@region} not empty."
          false
        end
      end

      def sdb
        @sdb ||= AWS::SimpleDB.new :access_key => @access_key,
                                   :secret_key => @secret_key,
                                   :region     => @region
      end

    end
  end
end
