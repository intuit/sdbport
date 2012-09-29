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

      def create_domain
        @simpledb.create_domain @name
      end

      def add_line(line)
        data = JSON.parse line.chomp
        id = data.first
        attributes = data.last
        @logger.debug "Adding #{id} with attributes #{attributes.to_s}."
        @simpledb.put_attributes @name, id, attributes
      end

      def ensure_domain_empty
        if @simpledb.domain_empty? @name
          true
        else
          @logger.error "Domain #{@name} in #{@region} not empty."
          false
        end
      end

    end
  end
end
