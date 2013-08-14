require 'rubygems'
require 'bundler/setup'

require 'sdbport'

def sdb_mock
  sdb_mock = mock 'simpledb'
  Sdbport::AWS::SimpleDB.should_receive(:new).
                         with(:access_key => 'the-key',
                              :secret_key => 'the-secret',
                              :region     => 'us-west-1').
                         and_return sdb_mock
  sdb_mock
end

def logger_mock
  logger_mock = mock 'logger'
  logger_mock.stub :info => true, :debug => true
  logger_mock
end

def logger_stub
  stub 'logger_stub', :info => true, :debug => true
end

RSpec.configure do |config|
  #spec config
end
