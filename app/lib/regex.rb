class Regex
  attr_reader :body

  def initialize(args = nil)
    args  = args.split(" ") if args.class == String
    @args = args || Args.new.values
    @body = regex? ? @args : combine
  end

  def match?(text)
    body =~ text && clean? 
  end

  private
  #
  # Open/Closed principle ... following methods are closed for modification
  #                           while aboves are open for it.
  #

  def clean?(text)
    return true if Args.new.negations.size == 0
    Args.new.negations.select {|neg| text.include?(neg) }.size == 0
  end

  def combine
    @args : Regexp.new(@args.join(".+"))
  end

  def regex?
    @args.class == Array
  end
end
