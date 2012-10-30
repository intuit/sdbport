require 'spec_helper'

describe Sdbport::CLI::Export do
  before do
    @domain_mock = mock "domain"
    @logger_stub = stub "logger"
    @options = { :name       => 'daname',
                 :region     => 'us-west-1',
                 :secret_key => 'private',
                 :access_key => 'abc',
                 :level      => 'debug',
                 :output     => '/test/file' }

    Sdbport::SdbportLogger.should_receive(:new).
                           with(:log_level => 'debug').
                           and_return @logger_stub
    @export = Sdbport::CLI::Export.new
  end

  it "should perform a in memeory write" do
    Trollop.stub :options => @options
    Sdbport::Domain.should_receive(:new).
                    with(:name       => 'daname',
                         :region     => 'us-west-1',
                         :secret_key => 'private',
                         :access_key => 'abc',
                         :logger     => @logger_stub).
                    and_return @domain_mock
    @domain_mock.should_receive(:export).with('/test/file').
                 and_return true
    @export.export
  end

  it "should perform a sequential write" do
    @options.merge! :write_as_you_go => true
    Trollop.stub :options => @options
    Sdbport::Domain.should_receive(:new).
                    with(:name       => 'daname',
                         :region     => 'us-west-1',
                         :secret_key => 'private',
                         :access_key => 'abc',
                         :logger     => @logger_stub).
                    and_return @domain_mock
    @domain_mock.should_receive(:export_sequential_write).
                 with('/test/file').
                 and_return true
    @export.export
  end
end
