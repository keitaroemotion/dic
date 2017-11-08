class Regex
  def initialize(args = nil)
    args = args.split(" ") if args.class == String
    @args = args || Args.new.values
  end

  def regex?
    @args.class == Array
  end

  def body
    regex? ? @args : combine
  end

  def combine
    regex? ? @args : Regexp.new(@args.join(".+"))
  end

  def list_matches(file)
    puts "\n[file] " + file.gsub("#{@location.raw}/", "").gsub(".md", "")
    File.read(file).split("\n").each do |line|
      # !(regex =~ line) || puts("... #{paint(line, @args.values)} ...\n")
      !(body =~ line) || puts("... #{line} ...\n")
    end  
  end

  def match?(text)
    body =~ text && clean? 
  end

  def clean?(text)
    return true if Args.new.negations.size == 0
    Args.new.negations.select {|neg| text.include?(neg) }.size == 0
  end
end
