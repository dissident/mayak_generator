module Mayak

  module AdminFields

    def form_image_field(attribute)
"f.input :#{attribute.name}, hint:
        [ \"Изображение будет уменьшено до размеров 280 на 150 пикселей, если оно большего размера.\",
          f.object.#{attribute.name}? ?
            \"<br>Текущее изображение:<br>\#{image_tag(f.object.#{attribute.name}.thumb.url)}\" : \"\"
        ].join.html_safe
      f.input :#{attribute.name}_cache, as: :hidden
      f.input :remove_#{attribute.name}, as: :boolean
      "
    end

    def form_text_field(attribute)
      "f.input :#{attribute.name}, input_html: { class: 'editor',
                                    'data-type' => f.object.class.name,
                                    'data-id' => f.object.id }
      "
    end

    def form_string_field(attribute)
      "f.input :#{attribute.name}
      "
    end

    def view_image_row(attribute, name)
      "row :#{attribute.name} do
        image_tag(#{name.underscore}.#{attribute.name}.url) unless #{name.underscore}.#{attribute.name}.blank?
      end
      "
    end

    def view_text_row(attribute, name)
      "row(:#{attribute.name}) { raw #{name.underscore}.#{attribute.name} }
      "
    end

    def view_string_field(attribute)
      "row :#{attribute.name}
      "
    end

    def index_image_column(attribute, name)
      "column :#{attribute.name} do |#{ name.underscore }|
        image_tag #{name.underscore}.#{attribute.name}.thumb.url
      end
      "
    end

    def index_string_column(attribute)
      "column :#{attribute.name}
      "
    end

  end
end
