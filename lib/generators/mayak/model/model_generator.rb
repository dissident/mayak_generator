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
        @permit_params = permit_params_string
        @form_inputs = form_inputs_string
        @index_columns = index_columns_string
        @view_rows = view_rows_string
        template "active_admin_resource.rb", "app/admin/#{@name.underscore}.rb"
      end

      def form_inputs_string
        @attributes.map do |attribute|
          case attribute.type
            when :image
              "f.input :#{attribute.name}, hint:
              \t[ \"Изображение будет уменьшено до размеров 280 на 150 пикселей, если оно большего размера.\",
              \t\tf.object.#{attribute.name}? ?
              \t\t\t\"<br>Текущее изображение:<br>\#{image_tag(f.object.#{attribute.name}.thumb.url)}\" : \"\"
              \t].join.html_safe
              f.input :#{attribute.name}_cache, as: :hidden
              f.input :remove_#{attribute.name}, as: :boolean
              "
            when :text
              "f.input :#{attribute.name}, input_html: { class: 'editor',
              \t\t'data-type' => f.object.class.name,
              \t\t'data-id' => f.object.id }
              "
            else
              "f.input :#{attribute.name}
              "
          end
        end.join("")
      end

      def index_columns_string
        @attributes.map do |attribute|
          case attribute.type
            when :image
              "column :#{attribute.name} do |#{ @name.underscore }|
              \t\timage_tag #{@name.underscore}.#{attribute.name}.thumb.url
              end
              "
            else
              "column :#{attribute.name}
              "
          end
        end.join("")
      end

      def view_rows_string
        @attributes.map do |attribute|
          case attribute.type
            when :image
              "row :#{attribute.name} do
              \timage_tag(#{@name.underscore}.#{attribute.name}.url) unless #{@name.underscore}.#{attribute.name}.blank?
              end
              "
            when :text
              "row(:#{attribute.name}) { raw #{@name.underscore}.#{attribute.name} }
              "
            else
              "row :#{attribute.name}
              "
          end
        end.join("")
      end

      def permit_params_string
        arrays = []
        @attributes.map do |attribute|
          case attribute.type
            when :has_many
              arrays << "#{attribute.name}_ids:[]"
              ""
            when :belongs_to
              ":#{attribute.name}_id"
            when :image
              ":#{attribute.name}, :#{attribute.name}_cache, :remove_#{attribute.name}"
            else
              ":#{attribute.name}"
          end
        end.concat(arrays).join(", ")
      end
    end
end
