require 'spec_helper'

describe Sdbport do

  before do
    @fog_mock = mock 'fog'
    @body_stub = mock 'body'
    Fog::AWS::SimpleDB.should_receive(:new).
                       with(:aws_access_key_id     => 'the-key',
                            :aws_secret_access_key => 'the-secret',
                            :region                => 'us-west-1').
                       and_return @fog_mock
    @sdb = Sdbport::AWS::SimpleDB.new :access_key => 'the-key',
                                      :secret_key => 'the-secret',
                                      :region     => 'us-west-1'
  end

  it "should list the domains in simples db" do
    @fog_mock.stub :list_domains => @body_stub
    @body_stub.should_receive(:body).
               and_return 'Domains' => ['domain1']
    @sdb.domains.should == ['domain1']
  end

  it "should perform select query given"
  it "should perform select query given and follow next token"

  it "should create a new domain when it does not exist" do
    @fog_mock.stub :list_domains => @body_stub
    @body_stub.stub :body => { 'Domains' => [] }
    @fog_mock.should_receive(:create_domain).with('new_domain')
    @sdb.create_domain_unless_present('new_domain')
  end

  it "should not create a new domain when already exists" do
    @fog_mock.stub :list_domains => @body_stub
    @body_stub.stub :body => { 'Domains' => ['new_domain'] }
    @fog_mock.should_receive(:create_domain).exactly(0).times
    @sdb.create_domain_unless_present('new_domain')
  end

  it "should destroy the specified domain" do
    @fog_mock.should_receive(:delete_domain).with('new_domain')
    @sdb.delete_domain('new_domain')
  end

  it "should update the attributes for an item" do
    @fog_mock.should_receive(:put_attributes).with('domain', 'key', {'key' => 'value'}, { "option" => "123" })
    @sdb.put_attributes('domain', 'key', {'key' => 'value'}, { "option" => "123" })
  end

  context "testing counts" do
    it "should count the number of entries in the domain" do
      data = { 'Items' => { 'Domain' => { 'Count' => ['1'] } } }
      @fog_mock.should_receive(:select).
                with('SELECT count(*) FROM `domain`').
                and_return @body_stub
      @body_stub.stub :body => data
      @sdb.count('domain').should == 1
    end

    it "should return true if no entries for the domain" do
      data = { 'Items' => { 'Domain' => { 'Count' => ['0'] } } }
      @fog_mock.should_receive(:select).
                with('SELECT count(*) FROM `domain`').
                and_return @body_stub
      @body_stub.stub :body => data
      @sdb.domain_empty?('domain').should be_true
    end

    it "should return false if entries exist for the domain" do
      data = { 'Items' => { 'Domain' => { 'Count' => ['50'] } } }
      @fog_mock.should_receive(:select).
                with('SELECT count(*) FROM `domain`').
                and_return @body_stub
      @body_stub.stub :body => data
      @sdb.domain_empty?('domain').should be_false
    end
  end

end
