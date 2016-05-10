require "minitest/autorun"
require "minitest/reporters"
require "./lib/modules/inserter"

Minitest::Reporters.use!

class IserterTest < Minitest::Test

  include Mayak::Inserter

  def setup
    @news_file = "./lib/modules/test_files/news.rb"
    @admin_user_file = "./lib/modules/test_files/admin_user.rb"
    FileUtils.cp "./lib/modules/test_files/news.rb", "./lib/modules/test_files/news_dub.rb"
    @dublicate_file = "./lib/modules/test_files/news_dub.rb"
  end

  def teardown
    FileUtils.rm "./lib/modules/test_files/news_dub.rb"
  end

  def test_news_has_private
    assert_equal has_private?(@news_file), true
  end

  def test_admin_user_has_no_private
    assert_equal has_private?(@admin_user_file), false
  end

  def test_news_has_validates_block
    assert_equal has_validate_block?(@news_file), true
  end

  def test_admin_user_has_no_validates_block
    assert_equal has_validate_block?(@admin_user_file), false
  end

  def test_news_has_uploaders
    assert_equal has_uploaders?(@news_file), true
  end

  def test_admin_user_has_no_uploaders
    assert_equal has_uploaders?(@admin_user_file), false
  end

  def test_news_has_scopes
    assert_equal has_scopes?(@news_file), true
  end

  def test_admin_user_has_no_scopes
    assert_equal has_scopes?(@admin_user_file), false
  end

  def test_news_has_acts_as
    assert_equal has_acts_as?(@news_file), true
  end

  def test_admin_user_has_no_acts_as
    assert_equal has_acts_as?(@admin_user_file), false
  end

end
