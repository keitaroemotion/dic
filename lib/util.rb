module Lib
  class Util
     def self.option?(arg)
       arg.start_with?("-")
     end
  end
end
