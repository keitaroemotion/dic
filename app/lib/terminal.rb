class Terminal
  attr_reader :input, :output
 
  def initialize(message: "> ", interactive: true, key_words: [], quit: true)
    @input     = ""
    @output    = message.join
    @key_words = key_words
    @quit      = quit
    interactive && ask_input 
  end

  def input_split
    @input.split(" ")
  end

  def list_basename(files)
    files.each_with_index { |c, i| puts "[#{i + 1}] #{File.basename(c)}" }
  end

  def list(list) 
    @output = list.each_with_index do |element, i|
      "#{i}: #{element.green}"
    end.join("\n")
    @output = "\n#{@output}\n"
    self
  end  

  def puts
    puts @output
    self
  end

  def paint
    (@key_words || @args.values).each do |key_word|
      @output = @output.gsub(key_word, key_word.green)
    end
    self
  end

  def ask_input
    print message
    @input = $stdin.gets.chomp
    abort if @input == "q".downcase.strip && @quit
  end

  def string
    @input.strip
  end

  def digit
    @input.downcase.to_i
  end
end
