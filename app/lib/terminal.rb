class Terminal
  def initialize(message: "> ", interactive: true, key_words: [])
    @input     = ""
    @output    = message.join
    @key_words = key_words
    interactive && ask_input 
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
    abort if @input == "q".downcase.strip
  end

  def string
    @input.strip
  end

  def digit
    @input.downcase.to_i
  end
end
