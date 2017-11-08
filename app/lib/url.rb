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

  #
  # XXX need refactor later
  # XXX the function "mutual_url" is missing
  #
  def mutually_insert(args = [])
    files = grep_list
    files.delete(@file)
    Terminal.new.list_basename(files)

    if files.size == 0
      puts "file not found".red
      mutual_url(@file, [])
    else
      input = Terminal.new("{@}> ", quit: false).string
      if /^\d+$/ =~ input
        file = files[(size < files.size ? size : 1) - 1]
        insert_url(file, @file); insert_url(@file, file)
        puts "\n[added!]\n".green
      elsif /^[q\s]+$/ =~ input
       # do nothing
      else
        mutual_url(@file, input.split(" "))
      end
    end  
  end

  def grep_list
    @wiki.original_articles.select { |article| Regex.new.match?(article) }
  end

  def url?(line)
    /^[\s\-]*\[[^\[\]]*\]\([^\(\)]+\)/ =~ line || /http[s]*:\/\// =~ line
  end

  def urls(file)
    File.read(file).split("\n").select { |line| url?(line) }
  end

  private

  def filter(line)
     /(\/usr\/local\/|http)[^\s\)\(]+/.match(line).to_s.split(" ").first 
  end
end
