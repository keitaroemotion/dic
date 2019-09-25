require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/location.rb"

class LocationTest < Minitest::Test
  def setup
    @location = Location.new(root: "test/source")
  end

  def test_config
    assert_equal "test/source/etc/vol/.config", @location.config
  end

  def test_etc
    assert_equal "test/source/etc/vol", @location.etc
  end

  def test_raw
    assert_equal "test/source/etc/vol/raw", @location.raw
  end

  def test_raw_images
    assert_equal "test/source/etc/vol/raw/images", @location.raw_images
  end

  def test_pages
    assert_equal "test/source/etc/vol/pages", @location.pages
  end

  def test_pages_images
    assert_equal "test/source/etc/vol/pages/images", @location.pages_images
  end
end
