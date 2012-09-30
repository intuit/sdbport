require 'spec_helper'

describe Sdbport do
  before do
    @logger_stub = logger_stub
    @sdb_mock = sdb_mock
    @file_mock = mock 'file'
    @export = Sdbport::Domain::Export.new :name       => 'name',
                                          :logger     => @logger_stub,
                                          :access_key => 'the-key',
                                          :secret_key => 'the-secret',
                                          :region     => 'us-west-1'
  end

  it "should export the domain to the given output" do
    File.should_receive(:open).with('/tmp/file', 'w').
                               and_return @file_mock
    data = { 'item1' => 
             { 'attribute' => [ 'value' ] },
             'item2' =>
             { 'attribute' => [ 'different' ] }
           }
    @sdb_mock.should_receive(:select).
              with('select * from `name`').
              and_return data
    @file_mock.should_receive(:write).with("[\"item1\",{\"attribute\":[\"value\"]}]")
    @file_mock.should_receive(:write).with("[\"item2\",{\"attribute\":[\"different\"]}]")
    @file_mock.should_receive(:write).with("\n").exactly(2).times
    @file_mock.should_receive(:close).and_return nil
    @export.export('/tmp/file').should be_true
  end

end
