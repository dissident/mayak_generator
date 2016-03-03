module Mayak

  module GeneratorHelper

    def model_exist?(name)
      Object.const_defined? name.camelize
    end

  end
end