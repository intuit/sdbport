require 'json'

module Sdbport
  class Domain
    class Import

      def initialize(args)
        @name       = args[:name]
        @logger     = args[:logger]
        @region     = args[:region]
        @access_key = args[:access_key]
        @secret_key = args[:secret_key]
        @region     = args[:region]
      end

      def import(input)
        create_domain

        return false unless ensure_domain_empty

        @logger.info "Importing #{@name} in #{@region} from #{input}."
        file = File.open(input, 'r')
        while (line = file.gets)
          add_line line
        end
        file.close
      end

      private

      def sdb
        @sdb ||= AWS::SimpleDB.new :access_key => @access_key,
                                   :secret_key => @secret_key,
                                   :region     => @region
      end

      def create_domain
        sdb.create_domain @name
      end

      def add_line(line)
        data = JSON.parse line.chomp
        id = data.first
        attributes = data.last
        @logger.debug "Adding #{id} with attributes #{attributes.to_s}."
        sdb.put_attributes @name, id, attributes
      end

      def ensure_domain_empty
        if sdb.domain_empty? @name
          true
        else
          @logger.error "Domain #{@name} in #{@region} not empty."
          false
        end
      end

    end
  end
end
