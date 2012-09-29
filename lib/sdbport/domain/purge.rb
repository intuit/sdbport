module Sdbport
  class Domain
    class Purge

      def initialize(args)
        @name     = args[:name]
        @logger   = args[:logger]
        @region   = args[:region]
        @simpledb = AWS::SimpleDB.new args
      end

      def purge
        @logger.info "Purging #{@name} in #{@region}."
        data = @simpledb.select "select * from #{@name}"
        data.keys.each do |key|
          @logger.debug "Deleting #{key}."
          @simpledb.delete @name, key
        end
      end

    end
  end
end
