require 'spec_helper'
require 'sdbport/cli'

describe Sdbport do
  before do
    @cli_mock = mock 'cli'
    @default_creds = { :access_key => 'the-key',
                       :secret_key => 'the-secret' }
    @config_stub = stub 'config', :access_key => 'the-key',
                                  :secret_key => 'the-secret'
    Sdbport::Config.stub :new => @config_stub
    @cli = Sdbport::CLI.new
  end

  it "should call destroy" do
    Sdbport::CLI::Destroy.should_receive(:new).
                          with(@default_creds).
                          and_return @cli_mock
    ARGV.stub :shift => 'destroy'
    @cli_mock.should_receive :destroy
    @cli.start
  end

  it "should call export" do
    Sdbport::CLI::Export.should_receive(:new).
                          with(@default_creds).
                          and_return @cli_mock
    ARGV.stub :shift => 'export'
    @cli_mock.should_receive :export
    @cli.start
  end

  it "should call import" do
    Sdbport::CLI::Import.should_receive(:new).
                          with(@default_creds).
                          and_return @cli_mock
    ARGV.stub :shift => 'import'
    @cli_mock.should_receive :import
    @cli.start
  end

  it "should call purge" do
    Sdbport::CLI::Purge.should_receive(:new).
                          with(@default_creds).
                          and_return @cli_mock
    ARGV.stub :shift => 'purge'
    @cli_mock.should_receive :purge
    @cli.start
  end
end
