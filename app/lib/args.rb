class Args
  #
  # SRP ... handles incoming argument and its sorting
  #

  def initialize(args)
    @args = args
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
end
