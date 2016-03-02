class <%= "#{@image.camelize}" %> < BaseImageUploader

  version :thumb do
    process resize_to_fill: [280, 150]
  end

end