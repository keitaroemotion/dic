require "minitest/autorun"
require "./test/test_helper.rb"
require "./app/lib/args.rb"

#
# TDD ... the class args should be tested fully
#

class ArgsTest < Minitest::Test
  def setup
    @args = Args.new(["moo", "-i", "^apple", "orange"]) 
  end

  def test_match?
    assert @args.match?("mooorange")
    assert @args.match?("moominorange")
    assert @args.match?("moo orange pp")
    refute @args.match?("moo orange apple")
    refute @args.match?("moo apple orange")
    refute @args.match?("apple moo orange")
    refute @args.match?("orange moo")
  end

  def test_negations
    assert_equal ["apple"], @args.negations
  end

  def test_options
    assert_equal ["-i"], @args.options
  end

  def test_values
    assert_equal ["moo", "orange"], @args.values
  end
end
