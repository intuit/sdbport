require 'spec_helper'

describe Sdbport do

  before do
    @fog_mock = mock 'fog'
    @body_stub = stub 'body'
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

  it "should perform select query given and next tokens" do
    body_stub0 = stub 'body0', :body => { 'Items' => 
                                            { 'id1' => 'val1' }, 
                                          'NextToken' => '1' 
                                        }
    body_stub1 = stub 'body1', :body => { 'Items' => 
                                            { 'id2' => 'val2' }, 
                                          'NextToken' => '2' 
                                        }
    body_stub2 = stub 'body2', :body => { 'Items' => 
                                            { 'id3' => 'val3' }
                                        }
    @fog_mock.should_receive(:select).
              with('select * from name', 'NextToken' => nil).
              and_return body_stub0
    @fog_mock.should_receive(:select).
              with('select * from name', 'NextToken' => '1').
              and_return body_stub1
    @fog_mock.should_receive(:select).
              with('select * from name', 'NextToken' => '2').
              and_return body_stub2
    @sdb.select_and_follow_tokens('select * from name').
         should == { 'id1' => 'val1',
                     'id2' => 'val2',
                     'id3' => 'val3' }
  end

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
    @fog_mock.should_receive(:batch_put_attributes).with('domain', { 'item1' => { 'key1' => 'value1' }, 
                                                                     'item2' => { 'key2' => 'value2' } })
    @sdb.batch_put_attributes('domain', { 'item1' => { 'key1' => 'value1' },
                                          'item2' => { 'key2' => 'value2' } })
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
