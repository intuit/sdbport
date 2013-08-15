require 'spec_helper'

describe Sdbport do
  before do
    @logger_stub = logger_stub
    @sdb_mock = sdb_mock
    @purge = Sdbport::Domain::Purge.new :name       => 'name',
                                        :logger     => @logger_stub,
                                        :access_key => 'the-key',
                                        :secret_key => 'the-secret',
                                        :region     => 'us-west-1'
  end

  it "should puge the given domain" do
    result = { 'item1' =>
               { 'attribute' => [ 'value' ] }
             }
    @sdb_mock.should_receive(:select_and_follow_tokens).
              with('select * from `name`').
              and_return result 
    @sdb_mock.should_receive(:delete).with 'name', 'item1'
    @purge.purge
  end
end
