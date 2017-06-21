require "minitest/autorun"
require "./test/test_helper.rb"
require "./lib/util.rb"
require 'FileUtils'

class Lib::UtilTest < Minitest::Test
  def setup
    @util = Lib::Util
  end

  def test_ask
    assert_equal "boiiin", @util.ask("oppai", "boiiin")
  end

  def test_copy
    # TBD
  end

  def test_desterisk
    # TBD
  end

  def write(file, content)
    f = File.open(file, "w")
    f.puts content
    f.close
  end

  def test_push_as_link
    dir  = "./etc/moomin_valley"

    def assert_suru(file, content, dir)
      require "colorize"
      puts file.green
      write(file, content)
      content = @util.push_as_link(dir, "floren", File.basename(file).gsub(".md", ""))
      FileUtils.rm file
      refute File.exist?(file)
      content
    end

    content = assert_suru("#{dir}/Links.md",    "\n# Links\n[oppai](boin)\n", dir)
    assert_equal "\n# Links\n[oppai](boin)\n[floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/links.md",    "\n# links\n[oppai](boin)\n", dir)
    assert_equal "\n# links\n[oppai](boin)\n[floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/Link.md",     "\n# Link\n[oppai](boin)\n", dir)
    assert_equal "\n# Link\n[oppai](boin)\n[floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/link.md",     "\n# link\n[oppai](boin)\n", dir)
    assert_equal "\n# link\n[oppai](boin)\n[floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/no_sharp.md", "\nlink\n[oppai](boin)\n", dir)
    assert_equal "\nlink\n[oppai](boin)\n\n# Link\n[floren](#{dir}/floren.md)\n", content

    content = assert_suru("#{dir}/missing.md",  "\n[oppai](boin)\n", dir)
    assert_equal "\n[oppai](boin)\n\n# Link\n[floren](#{dir}/floren.md)\n", content
  end

  def test_regex_okay?
    # TBD
  end

  def test_remove_markdown?
    assert_equal "moeee", @util.remove_markdown("[tsukasa](/hiiragi/moeee.md)")
  end

  def test_markdown_link_format?
    assert @util.markdown_link_format?("[izumi konata](/lucky/star/kagamin.md)")
    refute @util.markdown_link_format?("[izumi konata](/lucky/star/kagamin.md")
    # refute @util.markdown_link_format?("izumi konata](/lucky/star/kagamin.md)")
  end

  def test_match?
    refute @util.match?("precur*", "aprecure")
    assert @util.match?("precur*", "precure")
    assert @util.match?("pr*re", "precure")
    assert @util.match?("prec+re", "preccre")
    assert @util.match?("recur", "precure")
    assert @util.match?("*recure", "precure")
    refute @util.match?("*recu", "precure")
    assert @util.match?("p[a-z][eE0]cu[rR]e", "precure")
    assert @util.match?("*recur*", "precure")
    refute @util.match?("*racur*", "precure")
    assert @util.match?("p(recu|rocu)re", "precure")
    assert @util.match?("prec[^i]re", "precure")
  end
 
  def test_option?
    assert @util.option?("-a") 
    refute @util.option?("aa-") 
  end
end
