require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/wiki.rb"
require "./app/lib/args.rb"
require "./app/lib/location.rb"

class WikiTest < Minitest::Test
  describe "" do
    before do
      system "touch ./test/source/etc/vol/raw/moo_min_dani.md"
      system "touch ./test/source/etc/vol/pages/moo_min_dani.md"
      location = Location.new(root: "./test/source")
      args     = Args.new(["apple", "^banana", "fuji"])
      @wiki    = Wiki.new(location: location, args: args, editor: nil)
    end

    def test_create
      assert_equal "{editing} ./test/source/etc/vol/raw/moo_min_dani.md", @wiki.create(["moo", "min", "dani"]) 
    end

    def test_edit
      assert_equal "{editing} ./test/source/etc/vol/raw/moo_min_dani.md", @wiki.edit(["./test/source/etc/vol/raw/moo_min_dani.md"], 1) 
    end

    def test_original_articles
      assert_equal ["./test/source/etc/vol/raw/moo_min_dani.md"], @wiki.original_articles
    end

    def test_formatted_articles
      assert_equal ["./test/source/etc/vol/pages/moo_min_dani.md"], @wiki.formatted_articles
    end

    after do
      File.delete("./test/source/etc/vol/raw/moo_min_dani.md")
      File.delete("./test/source/etc/vol/pages/moo_min_dani.md")
    end
  end  
end
