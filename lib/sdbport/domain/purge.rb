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
      end

    end
  end
end
