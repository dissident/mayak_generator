require "#{MayakGenerator::Engine.root}/lib/modules/mayak_generator_helper"

module Mayak
  class M2mGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    include Mayak::GeneratorHelper

    desc "Use for generate custom mayak admin interface"

    def create
      unless ARGV.count == 2
        puts "Generator get only 2 params"
        return
      end
      first_model, second_model = ARGV.sort
      unless model_exist?(first_model)
        puts "model #{ first_model.camelize} not exist!"
        return
      end
      unless model_exist?(second_model)
        puts "model #{ second_model.camelize} not exist!"
        return
      end
      generate(:migration, "m2m_#{first_model.underscore}_#{second_model.underscore}")
      insert_into_file Dir["#{Rails.root}/db/migrate/*"].last, migration_text(first_model, second_model), after: "def change\n"
      inject_into_class "app/models/#{first_model.underscore}.rb", first_model.camelize do
        "  has_and_belongs_to_many :#{second_model.underscore.pluralize}\n"
      end
      inject_into_class "app/models/#{second_model.underscore}.rb", second_model.camelize do
        "  has_and_belongs_to_many :#{first_model.underscore.pluralize}\n"
      end
    end

    private

    def migration_text(first_model, second_model)
"   create_table :#{first_model.underscore.pluralize}_#{second_model.underscore.pluralize}, id: false do |t|
      t.belongs_to :#{first_model.underscore}, index: true
      t.belongs_to :#{second_model.underscore}, index: true
    end
"
    end

  end
end
