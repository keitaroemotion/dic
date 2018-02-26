require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/resource/image.rb"
require "./app/lib/location.rb"

class Resource::ImageTest < Minitest::Test
  def setup
    @location = Location.new
  end

  def test_embed
    embed = Resource::Image.new("![tag](images/image.jpg)", location: @location).embed
    assert_equal "![tag](images/image.jpg)", embed
    embed = Resource::Image.new("![tag](images/image.jpg 500)", location: @location).embed
    # assert_equal "![tag](images/image.jpg 500)", embed
  end
end
