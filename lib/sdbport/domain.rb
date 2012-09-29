require 'sdbport/domain/export'
require 'sdbport/domain/import'
require 'sdbport/domain/purge'

module Sdbport
  class Domain

    def initialize(args)
      @args = args
    end

    def import(input)
      domain_import.import input
    end

    def output(output)
      domain_export.export output
    end

    def purge
      domain_import.purge
    end

    private

    def domain_import
      @domain_import ||= Domain::Import.new @args
    end

    def domain_export
      @domain_export ||= Domain::Export.new @args
    end

    def domain_purge
      @domain_purge ||= Domain::Purge.new @args
    end

  end
end
