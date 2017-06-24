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

    def self.ask_no_abort(message, debug = nil)
      if debug
        debug
      else
        print "[#{message}] "
        option = $stdin.gets.chomp.downcase
        return false if option == "q"
        option
      end
    end

    def self.assure_file(file)
      unless File.exist?(file)
        f = File.open(file, "w")
        f.close
      end  
      file
    end

    def self.copy(from, to)
      puts "#{from} ---> #{to}".green
      system "cp #{from} #{to}"
    end
  
    def self.desterisk(regex)
      regex.gsub("*", "")
    end
 
    def self.include_all?(text, key_words)
      match_count = key_words.select{|kw| match?(kw, text)}.size
      match_count == key_words.size
    end

    def self.files_contains_keywords(files, key_words)
      files.select {|file| include_all?(file, key_words)}
    end

    def self.get_files(files, key_words)
      (files.size == 0 ? all_files : files_contains_keywords(files, key_words))
        .uniq
        .select{|x| x != "images"}
    end

    def self.http(link)
      /htt(p|ps)\:\/\/[^\)\( ]*/.match link
    end

    def self.image_link?(line)
      regex_okay?(/!\[[\w\d\s]*\]\([\d\s\w.\/ ]*\)/, line.strip)
    end

    def self.is_link?(line)
      regex_okay?(/^\[[\w\d\s\.\/]*\]\([\d\s\w.\/ ]*\)/, line.strip)
    end

    def self.md_image_link(line, root, shelf)
      tokens = line.split("](")
      ("!" + tokens[0].chomp + "](" + tokens[1..-1].join.gsub(root, ""))
        .gsub(shelf + "/", "").gsub("!!","!")
    end

    def self.pict_link?(line)
     Lib::Util.image_link?(line) && !line.include?("http")
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
      target_file = assure_file(File.join(wiki_dir, file_name_md))
      content = File.read(target_file)
      unless regex_okay?(/[\\#]\s*[Ll]ink/, content)
        content = "#{content}\n# Link\n"
      end
      f = File.open(target_file, "w")
      content += "\n[#{file_name}](#{File.join(wiki_dir, file_name)}.md)\n"
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

    def self.match?(regestr, target_string)
      stella_head = regestr.start_with?(STELLA)
      stella_tail = regestr.end_with?(STELLA)

      if stella_head && stella_tail  
        regestr = desterisk(regestr)
      else  
        regestr = stella_head ? "#{desterisk(regestr)}$" : regestr
        regestr = stella_tail ? "^#{desterisk(regestr)}" : regestr
      end
      
      !Regexp.new("#{regestr}").match(target_string).nil? 
    end

    def self.num?(num)
      num =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
    end

    def self.nasty_format?(file)
      /\.(xlsx|pdf|docx|xls)/.match(file)
    end

    def self.option?(arg)
      arg.start_with?("-")
    end

    def self.parse_link(link)
      title = /\[[\-\d\s\w\.\/]*\]/.match(link)
      [title.to_s, /\([\-\d\s\w\.\/]*\)/.match(link).to_s.gsub("(", "").gsub(")", "")]
    end

    def self.show(files)
      puts
      files.each_with_index { |file, i| puts "[#{i}] #{file}" }
      puts
    end

    def self.vim_prone_format?(file)
      /\.(txt|csv|yaml)/.match(file)
    end
  end
end
