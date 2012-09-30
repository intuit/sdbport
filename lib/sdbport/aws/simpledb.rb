require 'fog'

module Sdbport
  module AWS
    class SimpleDB

      def initialize(args)
        @access_key = args[:access_key]
        @secret_key = args[:secret_key]
        @region     = args[:region]
      end

      def domains
        sdb.list_domains.body['Domains']
      end

      def domain_exists?(domain)
        domains.include? domain
      end

      def create_domain_unless_present(domain)
        sdb.create_domain(domain) unless domain_exists?(domain)
      end

      def select(query, options = {})
        sdb.select(query, options).body
      end

      def select_and_follow_next_token(query)
        final_token = false
        next_token = ""
        data = {}
        until final_token == true
          chunk = sdb.select(query, 'NextToken' => next_token)
          data.merge! chunk['Items']
          next_token = chunk['NextToken'] if chunk['NextToken']
          final_token = true unless chunk['NextToken']
        end
        data
      end

      def count(domain)
        body = sdb.select("SELECT count(*) FROM `#{domain}`").body
        body['Items']['Domain']['Count'].first.to_i
      end

      def domain_empty?(domain)
        count(domain).zero?
      end

      def put_attributes(domain, key, attributes, options = {})
        sdb.put_attributes domain, key, attributes, options
      end

      def delete_domain(domain)
        sdb.delete_domain(domain)
      end

      def delete(domain, key)
        sdb.delete_attributes domain, key
      end

      private

      def sdb
        options =  { :aws_access_key_id     => @access_key,
                     :aws_secret_access_key => @secret_key,
                     :region                => @region }

        @sdb ||= Fog::AWS::SimpleDB.new options
      end

    end
  end
end
