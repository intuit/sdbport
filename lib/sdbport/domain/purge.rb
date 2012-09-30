module Sdbport
  class Domain
    class Purge

      def initialize(args)
        @name       = args[:name]
        @logger     = args[:logger]
        @access_key = args[:access_key]
        @secret_key = args[:secret_key]
        @region     = args[:region]
      end

      def purge
        @logger.info "Purging #{@name} in #{@region}."
        data = sdb.select_and_follow_next_token "select * from `#{@name}`"
        data.keys.each do |key|
          @logger.debug "Deleting #{key}."
          sdb.delete @name, key
        end
      end

      private

      def sdb
        @sdb ||= AWS::SimpleDB.new :access_key => @access_key,
                                   :secret_key => @secret_key,
                                   :region     => @region
      end

    end
  end
end
