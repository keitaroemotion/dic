require "minitest/autorun"
require "./test/test_helper.rb"
require "./lib/util.rb"

class Lib::UtilTest < Minitest::Test
  def setup
    @util = Lib::Util
  end

  def test_ask
    assert_equal "boiiin", @util.ask("oppai", "boiiin")
  end

  def test_desterisk
    # TBD
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
