require 'spec_helper'

describe Sdbport do

  before do
    @config = { 
                'test123' => {
                  'access_key' => 'key',
                  'secret_key' => 'secret' 
                }
              }
  end

  it "should create a new config object and read from ~/.sdbport.yml" do
    File.stub :exists? => true
    File.should_receive(:open).
         with("#{ENV['HOME']}/.sdbport.yml").
         and_return @config.to_yaml
    config = Sdbport::Config.new
    config.access_key('test123').should == 'key'
    config.secret_key('test123').should == 'secret'
  end

  it "should return nil if .sdbport.yml does not exist" do
    File.stub :exists? => false
    config = Sdbport::Config.new
    config.access_key('test123').should be_nil
    config.secret_key('test123').should be_nil
  end

end
