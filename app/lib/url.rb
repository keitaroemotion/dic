require "./app/lib/terminal.rb"

#
# little bit spaghetti still since there are several methods
# just brought from main boiler plate and not yet refactored
# 
class URL
  def initialize(files, input = "0")
    @file = files.class == Array ? Wiki.get(input, files) : files
    @wiki = Wiki.new
    @urls = []
  end

  def open(input, files)
    url = config["url"]
            .gsub("$", @file)
            .gsub(raw, "")
            .gsub("md.md", "md")
    system "open #{url}"
  end

  def initiate_urls
    File.read(@file).split("\n")
      .select { |line| url?(line) }
      .map    { |line| filter(line.strip) }
      .compact
      .uniq
  end

  def show
    return if @file.nil?
    @urls = @urls.size == 0 ? initiate_urls : @urls
    puts "#{File.basename(@file)}\n".cyan
    @urls.each_with_index { |l, i| puts "[#{i + 1}] #{l}" }
    input = Terminal.new(",{@}p>").string

    if /^[\,\s]+$/ =~ input
      puts "#{input.size} < #{@urls.size}".magenta
      system "open #{pick_url}"
    elsif /^[p\s]+$/ =~ input  
    else
      @urls = @urls.select{ |l| Regex.new(input).match?(l) }    
      show
    end
  end

  private 

  def pick_url(input)
    input = "," unless input.size - 1 < @urls.size
    @urls[input.size - 1]
  end

  def insert(file1, file2)
    f = File.open(file2, "a")
    base = base_name(file1)
    f.puts "- [#{base}](#{base}.md)"  
    f.close
  end

  def read_chapters(input, files)
    file = URL.new(files, input).file
    chapters = File.read(file).split("\n")
      .select { |line| /^[#]+/ =~ line }
      .map    { |line| line.gsub("#", "  ") }

    Terminal.new(interactive: false).enlist(chapters)

    file = chapters[Terminal.new("[chapter{@}]: ").digit]
    flag = 0
    File.read(file).split("\n").each do |line|
      if flag == 1
        return if /^[#]+/ =~ line
        puts line.magenta
      end
      flag = 1 if line.include?(title.strip)
    end   
  end

  #
  # XXX need refactor later
  #
  def mutually_insert(your_current_file, args = [])
    files = grep_list(
              args.size > 0 ? regex(args) : regex_args_stdin_split_with_space
            )
    files.delete(your_current_file)
    files.each_with_index { |c, i| puts "[#{i + 1}] #{File.basename(c)}" }

    if files.size == 0
      puts "file not found".red
        mutual_url(your_current_file, [])
    else
      print "{@}> "
      input = $stdin.gets.chomp
      if number?(input)
        size = 1 unless size < files.size
        file = files[size - 1]
        insert_url(file, your_current_file)
        insert_url(your_current_file, file)
        puts "\n[added!]\n".green
      elsif quit?(input) 
      else
        mutual_url(your_current_file, input.split(" "))
      end
    end  
  end

  def grep_list
    @wiki.original_articles.select { |article| body =~ article }
  end

  def regex_args_stdin_split_with_space
    print "?/ > "
    input = $stdin.gets.chomp
    abort if quit?(input)
    args = input.split(" ")
    args.size > 0 ? regex(args) : /^.*$/
  end

  def url?(line)
    /^[\s\-]*\[[^\[\]]*\]\([^\(\)]+\)/ =~ line || /http[s]*:\/\// =~ line
  end

  def urls(file)
    file_read_lines(file).select { |line| url?(line) }
  end

  private

  def filter(line)
     /(\/usr\/local\/|http)[^\s\)\(]+/.match(line).to_s.split(" ").first 
  end
end
