require 'json'

module Sdbport
  class Domain

    def initialize(options)
      @name     = options[:name]
      @output   = options[:output]
      @input    = options[:input]
      @simpledb = AWS::SimpleDB.new options
    end

    def export
      items = @simpledb.select "select * from #{@name}"
      file = File.open(@output, 'w')
      items.each do |item|
        file.write item.to_s + "\n"
      end
    end

    def import
      file = File.open(@input, 'r')
      while (line = file.gets)
        puts line
      end
      file.close
    end

    private

    def convert_item_to_json(item)
      item.to_json
    end

  end
end
