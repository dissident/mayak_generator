require "#{MayakGenerator::Engine.root}/lib/modules/mayak_generator_helper"
require "#{MayakGenerator::Engine.root}/lib/modules/model_fields"

module Mayak
  class ModelGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

    include Mayak::GeneratorHelper
    include Mayak::Inserter
    include Mayak::ModelFields

    desc "Use for generate custom mayak admin interface"

    def create
      if model_exist?(@name)
        puts "ERROR: model #{ @name.camelize } already exist"
        return
      end
      rails_attributes, mayak_attributes = process_attributes(attributes)
      generate :model, model_string(@name.camelize, rails_attributes)
      mayak_process mayak_attributes
    end

    private

    def process_attributes(attributes)
      rails_attributes = []
      mayak_attributes = []
      attributes.each do |attribute|
        case attribute.type
          when :image
            mayak_attributes << attribute
            rails_attribute = attribute.dup
            rails_attribute.type = :string
            rails_attributes << rails_attribute
          when :has_many
            mayak_attributes << attribute
          when :seo
            mayak_attributes << attribute
            rails_attribute = attribute.dup
            rails_attribute.type = :string
            rails_attribute.name = 'seodata'
            rails_attributes << rails_attribute
            @seo_check = true
          when :slug
            mayak_attributes << attribute
            rails_attribute = attribute.dup
            rails_attribute.type = :string
            rails_attribute.name = 'slug'
            rails_attributes << rails_attribute
          else
            rails_attributes << attribute
        end
      end
      [rails_attributes, mayak_attributes]
    end

    def mayak_process(attributes)
      attributes.each do |attribute|
        case attribute.type
          when :image
            @image = "#{@name.underscore}_#{attribute.name.underscore}_uploader"
            template "uploader.rb", "app/uploaders/#{@image}.rb"
            inject_into_class "app/models/#{@name.underscore}.rb", @name.camelize, "  mount_uploader :#{attribute.name.underscore}, #{@image.camelize}\n"
          when :has_many
            inject_into_class "app/models/#{@name.underscore}.rb", @name.camelize, "  has_many :#{attribute.name}, inverse_of: :#{@name.underscore}\n"
          when :seo
            inject_into_class "app/models/#{@name.underscore}.rb", @name.camelize, "  acts_as_seo_carrier\n"
          when :slug
            insert_private_method "app/models/#{@name.underscore}.rb", prepare_slug_private_method
            insert_filter "app/models/#{@name.underscore}.rb", slug_before_metod
        end
      end
    end

    def model_string(name, attributes)
      result = attributes.map { |a| a.type == :string ? "#{a.name}" : "#{a.name}:#{a.type}" }
      result.unshift name
      result.join(" ")
    end


  end
end
