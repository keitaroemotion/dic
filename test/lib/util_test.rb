require "minitest/autorun"
require "./test/test_helper.rb"
require "./lib/util.rb"

class Lib::UtilTest < Minitest::Test
  def setup
    @util = Lib::Util
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
