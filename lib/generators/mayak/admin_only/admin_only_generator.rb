require "#{MayakGenerator::Engine.root}/lib/modules/mayak_generator_helper"
require "#{MayakGenerator::Engine.root}/lib/modules/admin_fields"

module Mayak
  class AdminOnlyGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

    include Mayak::GeneratorHelper
    include Mayak::AdminFields

    desc "Use for generate custom mayak admin interface"

    def create
      @seo_check = false
      create_admin_interface
    end

    private

    def create_admin_interface
      @form_inputs = form_inputs_string
      @permit_params = permit_params_string
      @index_columns = index_columns_string
      @view_rows = view_rows_string
      @seo_form = "Seo::FormtasticSeoFieldset::build f" if @seo_check
      @seo_view = "seo_panel_for #{@name.underscore}" if @seo_check
      template "active_admin_resource.rb", "app/admin/#{@name.underscore}.rb"
    end

    def form_inputs_string
      @attributes.map do |attribute|
        case attribute.type
          when :image
            form_image_field(attribute)
          when :text
            form_text_field(attribute)
          when :seo
            @seo_check = true
            ""
          else
            form_string_field(attribute)
        end
      end.join("")
    end

    def index_columns_string
      @attributes.map do |attribute|
        case attribute.type
          when :image
            "column :#{attribute.name} do |#{ @name.underscore }|
                image_tag #{@name.underscore}.#{attribute.name}.thumb.url
            end
            "
          when :seo
            ""
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
              image_tag(#{@name.underscore}.#{attribute.name}.url) unless #{@name.underscore}.#{attribute.name}.blank?
            end
            "
          when :text
            "row(:#{attribute.name}) { raw #{@name.underscore}.#{attribute.name} }
            "
          when :seo
            ""
          else
            "row :#{attribute.name}
            "
        end
      end.join("")
    end

    def permit_params_string
      seo_params = @seo_check ? [":no_title_postfix", ":seo_title", ":seo_descr", ":seo_keywords"] : []
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
      end.concat(seo_params).concat(arrays).reject { |c| c.empty? }.join(", ")
    end

  end
end
