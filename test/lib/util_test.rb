require "minitest/autorun"
require "./test/test_helper.rb"
require "./lib/util.rb"

class Lib::UtilTest < Minitest::Test
  def setup
    @util = Lib::Util
  end

  def test_option?
    assert @util.option?("-a") 
    refute @util.option?("aa-") 
  end
end
