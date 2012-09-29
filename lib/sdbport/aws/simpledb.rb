require 'fog'

module Sdbport
  module AWS
    class SimpleDB

      def initialize(args)
        access_key = args[:access_key]
        secret_key = args[:secret_key]
        region     = args[:region]
        options =  { :aws_access_key_id     => access_key,
                     :aws_secret_access_key => secret_key,
                     :region                => region }

        @sdb = Fog::AWS::SimpleDB.new options
      end

      def select(query)
        @sdb.select(query).body['Items']
      end

      def count(domain)
        body = @sdb.select("SELECT count(*) FROM `#{domain}`").body
        body['Items']['Domain']['Count'].first.to_i
      end

    end
  end
end
