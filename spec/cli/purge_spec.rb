require 'spec_helper'

describe Sdbport::CLI::Purge do
  before do
    @domain_mock = mock "domain"
    @logger_stub = stub "logger"
    @options = { :name       => 'daname',
                 :region     => 'us-west-1',
                 :secret_key => 'private',
                 :access_key => 'abc',
                 :level      => 'debug' }

    Sdbport::SdbportLogger.should_receive(:new).
                           with(:log_level => 'debug').
                           and_return @logger_stub
    @purge = Sdbport::CLI::Purge.new
  end

  it "should perform a purge on the domain" do
    Trollop.stub :options => @options
    Sdbport::Domain.should_receive(:new).
                    with(:name       => 'daname',
                         :region     => 'us-west-1',
                         :secret_key => 'private',
                         :access_key => 'abc',
                         :logger     => @logger_stub).
                    and_return @domain_mock
    @domain_mock.should_receive(:purge).and_return true
    @purge.purge
  end

end
