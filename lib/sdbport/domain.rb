require 'sdbport/domain/destroy'
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

    def export(output)
      domain_export.export output
    end

    def purge
      domain_purge.purge
    end

    def destroy
      domain_destroy.destroy
    end

    private

    def domain_destroy
      @domain_destroy ||= Domain::Destroy.new @args
    end

    def domain_export
      @domain_export ||= Domain::Export.new @args
    end

    def domain_import
      @domain_import ||= Domain::Import.new @args
    end

    def domain_purge
      @domain_purge ||= Domain::Purge.new @args
    end

  end
end
