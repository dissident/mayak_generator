module Mayak

  module GeneratorHelper

    def model_exist?(name)
      #TODO работает плохо
      #Object.const_defined? name.camelize
      model_file_exist?(name)
    end

    def model_file_exist?(name)
      File.exist? "app/models/#{name.underscore}"
    end

  end
end
