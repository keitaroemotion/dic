require "minitest/autorun"
require "fileutils"
require "./test/test_helper.rb"
require "./app/lib/wiki.rb"
require "./app/lib/args.rb"
require "./app/lib/location.rb"

class WikiTest < Minitest::Test
  describe "" do
    before do
      @raw_file   = "./test/source/etc/vol/raw/moo_min_dani.md"
      @pages_file = "./test/source/etc/vol/pages/moo_min_dani.md"
      FileUtils.touch(@raw_file)
      FileUtils.touch(@pages_file)
      location = Location.new(root: "./test/source")
      args     = Args.new(["apple", "^banana", "fuji"])
      @wiki    = Wiki.new(location: location, args: args, editor: nil)
    end

    def test_create
      assert_equal "{editing} #{@raw_file}", @wiki.create(["moo", "min", "dani"]) 
    end

    def test_edit
      assert_equal "{editing} #{@raw_file}", @wiki.edit([@raw_file], 1) 
    end

    def test_original_articles
      assert_equal [@raw_file], @wiki.original_articles
    end

    def test_formatted_articles
      assert_equal [@pages_file], @wiki.formatted_articles
    end

    after do
      File.delete(@raw_file)
      File.delete(@pages_file)
    end
  end  
end
