require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/wiki.rb"
require "./app/lib/location.rb"

class WikiTest < Minitest::Test
  def setup
    @wiki     = Wiki.new(Location.new(root: "./app"))
  end

  #
  # TDD ... this class covers all the public methods of wiki.rb
  #

  def test_original_articles
    assert_equal ["./app/raw/apple.md"], @wiki.original_articles
  end

  def test_formatted_articles
    assert_equal ["./app/pages/apple.md"], @wiki.formatted_articles
  end
end
