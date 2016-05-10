# require "#{MayakGenerator::Engine.root}/lib/modules/mayak_generator_helper"
#
# module Mayak
#
#   class ModelGenerator < Rails::Generators::NamedBase
#
#     source_root File.expand_path('../templates', __FILE__)
#     argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
#
#     include Mayak::GeneratorHelper
#
#     desc "Use for generate custom mayak model"
#
#     def create
#       if model_exist?(@name)
#         puts "ERROR: model #{ @name.camelize } already exist"
#         return
#       end
#       @seo_check = false
#       rails_attributes, mayak_attributes = process_attributes(attributes)
#       generate :model, model_string(@name.camelize, rails_attributes)
#       mayak_process mayak_attributes
#       create_admin_interface
#     end
#
#     private
#
#     def process_attributes(attributes)
#       rails_attributes = []
#       mayak_attributes = []
#       attributes.each do |attribute|
#         case attribute.type
#           when :string
#             rails_attributes << attribute
#           when :image
#             mayak_attributes << attribute
#             rails_attribute = attribute.dup
#             rails_attribute.type = :string
#             rails_attributes << rails_attribute
#           when :belongs_to
#             rails_attributes << attribute
#           when :has_many
#             mayak_attributes << attribute
#           when :text
#             rails_attributes << attribute
#           when :seo
#             mayak_attributes << attribute
#             rails_attribute = attribute.dup
#             rails_attribute.type = :string
#             rails_attribute.name = 'seodata'
#             rails_attributes << rails_attribute
#             @seo_check = true
#         end
#       end
#       [rails_attributes, mayak_attributes]
#     end
#
#     def mayak_process(attributes)
#       attributes.each do |attribute|
#         case attribute.type
#           when :image
#             @image = "#{@name.underscore}_#{attribute.name.underscore}_uploader"
#             template "uploader.rb", "app/uploaders/#{@image}.rb"
#             inject_into_class "app/models/#{@name.underscore}.rb", @name.camelize, "  mount_uploader :#{attribute.name.underscore}, #{@image.camelize}\n"
#           when :has_many
#             inject_into_class "app/models/#{@name.underscore}.rb", @name.camelize, "  has_many :#{attribute.name}, inverse_of: :#{@name.underscore}\n"
#           when :seo
#             inject_into_class "app/models/#{@name.underscore}.rb", @name.camelize, "  acts_as_seo_carrier\n"
#         end
#       end
#     end
#
#     def model_string(name, attributes)
#       result = attributes.map { |a| a.type == :string ? "#{a.name}" : "#{a.name}:#{a.type}" }
#       result.unshift name
#       result.join(" ")
#     end
#
#     def create_admin_interface
#       @permit_params = permit_params_string
#       @form_inputs = form_inputs_string
#       @index_columns = index_columns_string
#       @view_rows = view_rows_string
#       @seo_form = "Seo::FormtasticSeoFieldset::build f" if @seo_check
#       @seo_view = "seo_panel_for #{@name.underscore}" if @seo_check
#       template "active_admin_resource.rb", "app/admin/#{@name.underscore}.rb"
#     end
#
#     def form_inputs_string
#       @attributes.map do |attribute|
#         case attribute.type
#           when :image
#             "f.input :#{attribute.name}, hint:
#               [ \"Изображение будет уменьшено до размеров 280 на 150 пикселей, если оно большего размера.\",
#                 f.object.#{attribute.name}? ?
#                   \"<br>Текущее изображение:<br>\#{image_tag(f.object.#{attribute.name}.thumb.url)}\" : \"\"
#               ].join.html_safe
#             f.input :#{attribute.name}_cache, as: :hidden
#             f.input :remove_#{attribute.name}, as: :boolean
#             "
#           when :text
#             "f.input :#{attribute.name}, input_html: { class: 'editor',
#                 'data-type' => f.object.class.name,
#                 'data-id' => f.object.id }
#             "
#           when :seo
#             ""
#           else
#             "f.input :#{attribute.name}
#             "
#         end
#       end.join("")
#     end
#
#     def index_columns_string
#       @attributes.map do |attribute|
#         case attribute.type
#           when :image
#             "column :#{attribute.name} do |#{ @name.underscore }|
#                 image_tag #{@name.underscore}.#{attribute.name}.thumb.url
#             end
#             "
#           when :seo
#             ""
#           else
#             "column :#{attribute.name}
#             "
#         end
#       end.join("")
#     end
#
#     def view_rows_string
#       @attributes.map do |attribute|
#         case attribute.type
#           when :image
#             "row :#{attribute.name} do
#               image_tag(#{@name.underscore}.#{attribute.name}.url) unless #{@name.underscore}.#{attribute.name}.blank?
#             end
#             "
#           when :text
#             "row(:#{attribute.name}) { raw #{@name.underscore}.#{attribute.name} }
#             "
#           when :seo
#             ""
#           else
#             "row :#{attribute.name}
#             "
#         end
#       end.join("")
#     end
#
#     def permit_params_string
#       seo_params = @seo_check ? [":no_title_postfix", ":seo_title", ":seo_descr", ":seo_keywords"] : []
#       arrays = []
#       @attributes.map do |attribute|
#         case attribute.type
#           when :has_many
#             arrays << "#{attribute.name}_ids:[]"
#             ""
#           when :belongs_to
#             ":#{attribute.name}_id"
#           when :image
#             ":#{attribute.name}, :#{attribute.name}_cache, :remove_#{attribute.name}"
#           else
#             ":#{attribute.name}"
#         end
#       end.concat(seo_params).concat(arrays).join(", ")
#     end
#   end
# end
