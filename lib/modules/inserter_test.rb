require "minitest/autorun"
require "minitest/reporters"
require "./lib/modules/inserter"
require "./lib/modules/model_fields.rb"

Minitest::Reporters.use!

class IserterTest < Minitest::Test

  include Mayak::Inserter
  include Mayak::ModelFields

  def setup
    @news_file = "./lib/modules/test_files/news.rb"
    @admin_user_file = "./lib/modules/test_files/admin_user.rb"
    FileUtils.cp "./lib/modules/test_files/news.rb", "./lib/modules/test_files/news_dub.rb"
    FileUtils.cp "./lib/modules/test_files/admin_user.rb", "./lib/modules/test_files/admin_user_dub.rb"
    @dublicate_file_news = "./lib/modules/test_files/news_dub.rb"
    @dublicate_file_admin_user = "./lib/modules/test_files/admin_user_dub.rb"
  end

  def teardown
    FileUtils.rm "./lib/modules/test_files/news_dub.rb"
    FileUtils.rm "./lib/modules/test_files/admin_user_dub.rb"
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

  def test_news_has_method_set_defaults
    assert_equal has_method?(@news_file, "set_defaults"), true
  end

  def test_admin_user_has_no_method_set_defaults
    assert_equal has_method?(@admin_user_file, "set_defaults"), false
  end

  def test_insert_method_news
    result = { was: false, now: false }
    result[:was] = has_private?(@dublicate_file_news)
    insert_private_method(@dublicate_file_news, prepare_slug_private_method)
    result[:now] = has_method?(@dublicate_file_news, "prepare_slug")
    assert_equal result, { was: true, now: true }
  end

  def test_insert_method_admin_user
    result = { was: false, now: false }
    result[:was] = has_private?(@dublicate_file_admin_user)
    insert_private_method(@dublicate_file_admin_user, prepare_slug_private_method)
    result[:now] = has_method?(@dublicate_file_admin_user, "prepare_slug")
    assert_equal result, { was: false, now: true }
  end

  def test_find_string_by_regex_news
    regex = /acts_as_/
    assert_equal find_last_string_by_regex(@news_file, regex), "  acts_as_static_files_holder\n"
  end

  def test_find_string_by_regex_admin_user
    regex = /acts_as_/
    assert_equal find_last_string_by_regex(@admin_user_file, regex), nil
  end

  def test_insert_filter_to_news
    insert_filter(@dublicate_file_news, slug_before_metod)
    assert_equal find_last_string_by_regex(@dublicate_file_news, /before\_validation\ \:prepare\_slug/), "  before_validation :prepare_slug\n"
  end

end
