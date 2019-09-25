class Args
  #
  # SRP ... handles incoming argument and its sorting
  #

  def initialize(args)
    @args = args.class == String ? args.split(" ") : args
  end

  def match?(text)
    positive_regex =~ text && negative_regex =~ text
  end

  def negations
    @args.select{|a| /^[\^]/ =~ a }.map{|a| a[1..-1]}
  end

  def options
    @args.select{|a| /^\-[^\^]+$/ =~ a }
  end

  def values
    @args.select{|a| /^[^\-\^]/ =~ a }
  end

  private

  def negative_regex
    negations.empty? ? /^$/ : Regexp.new("^((?!#{negations.join(".+")}).)*$")
  end

  def positive_regex
    values.empty? ? /.+/ : Regexp.new(values.join(".*"))
  end
end
