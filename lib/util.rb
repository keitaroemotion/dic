require "colorize"

module Lib
  class Util
     STELLA = "*"

      def self.ask(message, debug = nil)
       if debug
         debug
       else
         print "[#{message}] "
         option = $stdin.gets.chomp.downcase
         abort if option == "q"
         option
       end
     end
    
     def self.desterisk(regex)
       regex.gsub("*", "")
     end

     #
     # TODO:  this part is too verbose and boilerplate. needs to be refactored
     #
     def self.push_as_link(wiki_dir, file_name, dest = nil, debug = nil)
       file_name_md = ""
       if dest
         file_name_md = dest + ".md"
       else
         file_name_md = ask("dest:", debug) + ".md"
       end
       target_file = File.join(wiki_dir, file_name_md)
       content = File.read(target_file)
       unless regex_okay?(/[\\#]\s*[Ll]ink/, content)
         content = "#{content}\n# Link\n"
       end
       f = File.open(target_file, "w")
       content += "[#{file_name}](#{File.join(wiki_dir, file_name)}.md)\n"
       f.puts(content)
       f.close
       File.open(target_file, "r").each do |line|
         puts line.include?(file_name) ? line.magenta : line
       end
       File.read(target_file)
     end

     def self.regex_okay?(regex, text)
       !regex.match(text).nil?
     end

     def self.purge(text:, enemies:)
       enemies.each do |enemy|
         text = text.gsub(enemy, "")
       end
       text
     end

     def self.remove_markdown(link)
       purge(
         text:    File.basename(link.split("](")[1]),
         enemies: [")", "[", ".md"]
       )  
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
