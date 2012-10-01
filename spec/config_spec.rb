require 'spec_helper'

describe Sdbport do

  before do
    @config = { 'access_key ' => 'key',
                'secret_key ' => 'secret' }
  end

  it "should create a new config object from the hash passed as config" do
    config = Sdbport::Config.new :config => @config
    config.access_key.should == @config['access_key']
    config.secret_key.should == @config['secret_key']
  end

  it "should create a new config object and read from ~/.sdbport.yml" do
    File.stub :exists? => true
    File.should_receive(:open).
         with("#{ENV['HOME']}/.sdbport.yml").
         and_return @config.to_yaml
    config = Sdbport::Config.new
    config.access_key.should == @config['access_key']
    config.secret_key.should == @config['secret_key']
  end

  it "should load a blank config if the file does not exist and no config passed" do
    File.stub :exists? => false
    config = Sdbport::Config.new
    config.access_key.should be_nil
    config.secret_key.should be_nil
  end

end
