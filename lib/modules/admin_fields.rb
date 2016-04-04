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
  end
end
