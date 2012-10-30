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

      def select_and_follow_tokens(query, options = {})
        data = {}
        next_token = nil
        final_token = false
        while true
          options.merge! 'NextToken' => next_token
          chunk = sdb.select(query, options).body
          data.merge! chunk['Items']
          next_token = chunk['NextToken']
          return data unless next_token
        end
      end

      def select_and_store_chunk_of_tokens(query, options = {})
        options.merge! 'NextToken' => @token_for_next_chunk
        chunk = sdb.select(query, options).body
        @token_for_next_chunk = chunk['NextToken']
        return chunk['Items']
      end

      def more_chunks?
        @token_for_next_chunk != nil
      end

      def count(domain)
        body = sdb.select("SELECT count(*) FROM `#{domain}`").body
        body['Items']['Domain']['Count'].first.to_i
      end

      def domain_empty?(domain)
        count(domain).zero?
      end

      def batch_put_attributes(domain,  attributes)
        sdb.batch_put_attributes domain, attributes
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
