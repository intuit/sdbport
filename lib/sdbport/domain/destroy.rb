module Sdbport
  class Domain
    class Destroy

      def initialize(args)
        @name       = args[:name]
        @logger     = args[:logger]
        @access_key = args[:access_key]
        @secret_key = args[:secret_key]
        @region     = args[:region]
      end

      def destroy
        @logger.info "Destroying #{@name} in #{@region}."
        sdb.delete_domain @name
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
