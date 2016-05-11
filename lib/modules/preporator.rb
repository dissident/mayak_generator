module Mayak
  module Preporator

    def prepare_model(model)
      class Field < Struct.new(:name, :type, :index)
        def initialize(name, type, index=false); super end
      end
      result = []
      model.columns.each do |column|
        mayak_field = Field.new
        case column.type
        when :string
          case column.name
          when 'slug'
            mayak_field.name = column.name
            mayak_field.type = :slug
            result << mayak_field
          when 'seodata'
            mayak_field.name = column.name
            mayak_field.type = :seo
            result << mayak_field
          else
            if is_uploader?(model, column.name)
              mayak_field.name = column.name
              mayak_field.type = :image
              result << mayak_field
            else
              mayak_field.name = column.name
              mayak_field.type = column.type
              result << mayak_field
            end
          end
        when :integer
          unless column.name == 'id'
            mayak_field.name = column.name
            mayak_field.type = column.type
            result << mayak_field
          end
        else
          mayak_field.name = column.name
          mayak_field.type = column.type
          result << mayak_field
        end
        result
      end
    end

    private

    def is_uploader?(model, filed)
      File.readlines("./app/models/#{model}.rb").select { |string| string.include?("mount_uploader :#{filed}") }.size > 0
    end

  end

end
