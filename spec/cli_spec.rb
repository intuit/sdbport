require 'spec_helper'
require 'sdbport/cli'

describe Sdbport do
  before do
    @cli_mock = mock 'cli'
    @config_stub = stub 'config', :access_key => 'the-key',
                                  :secret_key => 'the-secret'
    Sdbport::Config.stub :new => @config_stub
    @cli = Sdbport::CLI.new
  end

  it "should call destroy" do
    Sdbport::CLI::Destroy.stub :new => @cli_mock
    ARGV.stub :shift => 'destroy'
    @cli_mock.should_receive :destroy
    @cli.start
  end

  it "should call export" do
    Sdbport::CLI::Export.stub :new => @cli_mock
    ARGV.stub :shift => 'export'
    @cli_mock.should_receive :export
    @cli.start
  end

  it "should call import" do
    Sdbport::CLI::Import.stub :new => @cli_mock
    ARGV.stub :shift => 'import'
    @cli_mock.should_receive :import
    @cli.start
  end

  it "should call purge" do
    Sdbport::CLI::Purge.stub :new => @cli_mock
    ARGV.stub :shift => 'purge'
    @cli_mock.should_receive :purge
    @cli.start
  end
end
