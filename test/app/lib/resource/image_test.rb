require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/resource/image.rb"

class Resource::ImageTest < Minitest::Test
  def test_embeds
    embeds = Resource::Image.new("![tag](images/image.jpg)").embeds
    assert_equal "![tag](images/image.jpg)", embeds
    embeds = Resource::Image.new("![tag](images/image.jpg 500)").embeds
    # assert_equal "![tag](images/image.jpg 500)", embeds
  end
end
