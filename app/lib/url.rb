require "./app/lib/terminal.rb"

class URL
  def initialize(files, input = "0")
    @file = files.class == Array ? Wiki.get(input, files) : files
  end

  def open(input, files)
    url = config["url"]
            .gsub("$", @file)
            .gsub(raw, "")
            .gsub("md.md", "md")
    system "open #{url}"
  end

  def show(links = [])
    return if @file.nil?
    if links.size == 0
      links = File.read(@file).split("\n")
        .select { |line| link?(line) }
        .map    { |line|
          /(\/usr\/local\/|http)[^\s\)\(]+/.match(line.strip).to_s.split(" ").first 
        }
        .compact
        .uniq
    end    
    puts "#{File.basename(@file)}\n".cyan
    links.each_with_index { |l, i| puts "[#{i + 1}] #{l}" }
    input = Terminal.ask_input(",{@}p>")
    abort if input == "q".downcase.strip

    if /^[\,\s]+$/ =~ input
      puts "#{input.size} < #{links.size}".magenta
      input = "," unless input.size - 1 < links.size
      system "open #{links[input.size - 1]}"
    elsif /^[p\s]+$/ =~ input  
    else
      r = regex(input.split(" "))
      show(links.select{ |l| r =~ l } )    
    end
  end

  def insert(file1, file2)
    f = File.open(file2, "a")
    base = base_name(file1)
    f.puts "- [#{base}](#{base}.md)"  
    f.close
  end

  def mutually_insert(your_current_file, args = [])
    files = files_match_pattern(
              args.size > 0 ? regex(args) : regex_args_stdin_split_with_space
            )
    files.delete(your_current_file)
            
    disp_files(files)

    if files.size == 0
      puts "file not found".red
        mutual_link(your_current_file, [])
    else
      print "{@}> "
      input = $stdin.gets.chomp
      if number?(input)
        size = 1 unless size < files.size
        file = files[size - 1]
        insert_link(file, your_current_file)
        insert_link(your_current_file, file)
        puts "\n[added!]\n".green
      elsif quit?(input) 
      else
        mutual_link(your_current_file, input.split(" "))
      end
    end  
  end

  def regex_args_stdin_split_with_space
    print "?/ > "
    input = $stdin.gets.chomp
    abort if quit?(input)
    args = input.split(" ")
    args.size > 0 ? regex(args) : /^.*$/
  end

  def link?(line)
    /^[\s\-]*\[[^\[\]]*\]\([^\(\)]+\)/ =~ line || /http[s]*:\/\// =~ line
  end

  def links(file)
    file_read_lines(file).select { |line| link?(line) }
  end
end
