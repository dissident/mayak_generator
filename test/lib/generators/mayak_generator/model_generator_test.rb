require 'test_helper'
require 'generators/model/model_generator'

module MayakGenerator
  class ModelGeneratorTest < Rails::Generators::TestCase
    tests ModelGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
