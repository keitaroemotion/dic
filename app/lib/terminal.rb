class Terminal
  class << self
    def ask_input(msg = "[,{@}pyna/vwu]> ")
      print msg
      $stdin.gets.chomp.strip
    end
  end  
end
