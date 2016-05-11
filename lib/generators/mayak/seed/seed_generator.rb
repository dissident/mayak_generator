require "#{MayakGenerator::Engine.root}/lib/modules/preporator"

module Mayak
  class SeedGenerator < Rails::Generators::Base

    include Mayak::Preporator

    source_root File.expand_path('../templates', __FILE__)

    desc "Use for generate custom mayak seed"

    def create
      unless ARGV.count == 1
        puts "Generator get only 1 param"
        return
      end
      model = ARGV.first
      p prepare_model(model)
    end
  end
end
