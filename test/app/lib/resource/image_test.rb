require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/resource/image.rb"

class Resource::ImageTest < Minitest::Test
  def test_embed
    embed = Resource::Image.new("![tag](images/image.jpg)").embed
    assert_equal "![tag](images/image.jpg)", embed
    embed = Resource::Image.new("![tag](images/image.jpg 500)").embed
    # assert_equal "![tag](images/image.jpg 500)", embed
  end
end
