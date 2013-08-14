require 'spec_helper'

describe Sdbport::Cli::Import do
  before do
    @domain_mock = mock "domain"
    @logger_stub = stub "logger"
    @options = { :name       => 'daname',
                 :region     => 'us-west-1',
                 :secret_key => 'private',
                 :access_key => 'abc',
                 :level      => 'debug',
                 :input      => '/test/file' }

    Sdbport::SdbportLogger.should_receive(:new).
                           with(:log_level => 'debug').
                           and_return @logger_stub
    @import = Sdbport::Cli::Import.new
  end

  it "should perform an import from file" do
    Trollop.stub :options => @options
    Sdbport::Domain.should_receive(:new).
                    with(:name       => 'daname',
                         :region     => 'us-west-1',
                         :secret_key => 'private',
                         :access_key => 'abc',
                         :logger     => @logger_stub).
                    and_return @domain_mock
    @domain_mock.should_receive(:import).with('/test/file').
                 and_return true
    @import.import
  end

end
