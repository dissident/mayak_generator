module Mayak

    class ModelGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"


      desc "Use for generate custom mayak model"

      def create
        if model_exist?(@name)
          puts "ERROR: model #{ @name.camelize } already exist"
          return
        end
        rails_attributes, mayak_attributes = process_attributes(attributes)
        generate :model, model_string(@name.camelize, rails_attributes)
        mayak_process mayak_attributes
        create_admin_interface
      end

      private

      def process_attributes(attributes)
        rails_attributes = []
        mayak_attributes = []
        attributes.each do |attribute|
          case attribute.type
            when :string
              rails_attributes << attribute
            when :image
              mayak_attributes << attribute
              rails_attribute = attribute.dup
              rails_attribute.type = :string
              rails_attributes << rails_attribute
            when :belongs_to
              rails_attributes << attribute
            when :has_many
              mayak_attributes << attribute
            when :text
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
          end
        end
      end

      def model_string(name, attributes)
        result = attributes.map { |a| a.type == :string ? "#{a.name}" : "#{a.name}:#{a.type}" }
        result.unshift name
        result.join(" ")
      end

      def model_exist?(name)
        Object.const_defined? name.camelize
      end

      def create_admin_interface
        template "active_admin_resource.rb", "app/admin/#{@name.underscore}.rb"
      end
    end
end
