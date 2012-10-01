require 'spec_helper'

describe Sdbport do

  before do
    @logger_stub = logger_stub
    @sdb_mock = sdb_mock
    options = { :name       => 'name',
                :logger     => @logger_stub,
                :access_key => 'the-key',
                :secret_key => 'the-secret',
                :region     => 'us-west-1' }
    @destroy = Sdbport::Domain::Destroy.new options
  end

  it "should delete the given domain" do
    @sdb_mock.should_receive(:delete_domain)
    @destroy.destroy
  end

end
