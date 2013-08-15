require 'spec_helper'

describe Sdbport do
  before do
    @logger_mock = logger_mock
    @sdb_mock = sdb_mock
    @file_mock = mock 'file'
    @import = Sdbport::Domain::Import.new :name       => 'name',
                                          :logger     => @logger_mock,
                                          :access_key => 'the-key',
                                          :secret_key => 'the-secret',
                                          :region     => 'us-west-1'
  end

  context "when successful" do
    it "should import from the given input" do
      @line1 = '["itemA", {"key":["val1", "val2"]}]'
      @line2 = '["itemB", {"key":["val3", "val4"]}]'
      @sdb_mock.should_receive(:create_domain_unless_present).
                with('name')
      @sdb_mock.should_receive(:domain_empty?).with('name').
                and_return true
      File.should_receive(:open).with('/tmp/file', 'r').
                                 and_return @file_mock
      @file_mock.should_receive(:gets).and_return @line1
      @file_mock.should_receive(:gets).and_return @line2
      @sdb_mock.should_receive(:batch_put_attributes).
                with("name", { "itemA" => {
                                 "key" => ["val1", "val2"]
                               }, 
                               "itemB" => {
                                 "key" => ["val3", "val4"]
                               } })
      @file_mock.should_receive(:gets).and_return nil
      @import.import('/tmp/file').should be_true
    end
  end

  context "when unsuccessful" do
    it "should return false if the domain is not empty" do
      @sdb_mock.should_receive(:create_domain_unless_present).
                with('name')
      @sdb_mock.should_receive(:domain_empty?).with('name').
                and_return false
      @logger_mock.should_receive(:error)
      @import.import('/tmp/file').should be_false
    end
  end

end
