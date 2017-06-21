module Lib
  class Util
     STELLA = "*"
     
     def self.desterisk(regex)
       regex.gsub("*", "")
     end

     def self.regex_okay?(regex, text)
       !regex.match(text).nil?
     end

     def self.markdown_link_format?(link)
       regex_okay?(/^\[[\w\s]*\]\([\w\s.\/ ]*\)/, link)
     end

     def self.match?(regex, target_string)
       stella_head = regex.start_with?(STELLA)
       stella_tail = regex.end_with?(STELLA)

       if stella_head && stella_tail  
         regex = desterisk(regex)
       else  
         regex = stella_head ? "#{desterisk(regex)}$" : regex
         regex = stella_tail ? "^#{desterisk(regex)}" : regex
       end
       
       !Regexp.new("#{regex}").match(target_string).nil? 
     end

     def self.option?(arg)
       arg.start_with?("-")
     end
  end
end
