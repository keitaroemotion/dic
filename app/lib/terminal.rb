class Terminal
  def initialize(message: "> ", interactive: true)
    @input = ""
    interactive && ask_input 
  end

  def enlist(list) 
    puts
    list.each_with_index do |element, i|
      puts "#{i}: #{element.green}"
    end
    puts
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
