require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/resource/base.rb"
require "./app/lib/location.rb"
require "fileutils"

class Resource::BaseTest < Minitest::Test
  describe "" do 
    before do
      system "touch image.jpg"
      @base     = Resource::Base.new(resources: ["image.jpg"], location: Location.new(root: "./test/source"))
    end

    def test_append_sys_command
      regex = /echo\s\"\!\[image\]\(\.\/test\/source\/etc\/vol\/pages\/images\/\d+.jpg\)\"\s\|\spbcopy/
      assert_match regex, @base.append_sys_command 
      assert_equal 1, pages_images.size
      assert_match /\.\/test\/source\/etc\/vol\/pages\/images\/\d+.jpg/, pages_images.first  
      assert_equal 1, raw_images.size
      assert_match /\.\/test\/source\/etc\/vol\/raw\/images\/\d+.jpg/, raw_images.first  
    end

    after do
      (["image.jpg"] + raw_images + pages_images).each { |image| File.delete(image) }
    end

    def pages_images
      Dir["./test/source/etc/vol/pages/images/*"]
    end

    def raw_images
      Dir["./test/source/etc/vol/raw/images/*"]
    end
  end  
end
