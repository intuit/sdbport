require 'spec_helper'

require 'sdbport/cli'

describe Sdbport::Cli::Destroy do
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
    @destroy = Sdbport::Cli::Destroy.new
  end

  it "should perform destroy the domain" do
    Trollop.stub :options => @options
    Sdbport::Domain.should_receive(:new).
                    with(:name       => 'daname',
                         :region     => 'us-west-1',
                         :secret_key => 'private',
                         :access_key => 'abc',
                         :logger     => @logger_stub).
                    and_return @domain_mock
    @domain_mock.should_receive(:destroy).and_return true
    @destroy.destroy
  end

end
