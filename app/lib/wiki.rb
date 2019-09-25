require "./app/lib/location.rb"

class Wiki
  attr_reader :original_articles, :formatted_articles
  #
  # SRP ... all wiki files/contents are `encapsulated` into a object `wiki`
  #
  def initialize(location:, args: nil, file: nil, debug: false)
    @location           = location
    @debug              = debug
    @file               = file
    @args               = args
    @args               = args.strip.split(" ") if args.class == String
    @original_articles  = articles(@location.raw)
    @formatted_articles = articles(@location.pages)
  end

  def create(args)
    sys_edit("#{@location.raw}/#{args.join('_')}.md")
  end

  def edit(files, size)
    size = 1 unless size < files.size
    sys_edit("#{@editor} #{files[size - 1]}")
  end

  def grep
    original_articles
      .select { |file| @args.match?(read) }
      .each   { |file| list_matches(file) }
  end

  def read(file = @file)
    File.read(file).split("\n") 
  end

  #
  # XXX test
  #
  def save
    sys_git ([
      "cd #{@location.root}",
      "git add #{@location.root}",
      "git commit -m \"page updated\"",
      "git pull origin master",
      "git push origin master",
    ].join(";"))
  end

  def self.get(input, files)
    file_index = input.strip.size - 1
    file_index = 0 unless file_index < files.size
    files[file_index]
  end  

  #
  # XXX test
  #
  def update
    @wiki.original_articles.each { |file| convert_raw(file) }
    backup
    @wiki.formatted_articles.each { |file| convert_page(file) }
    sys_git("cd #{@root}; git --no-pager diff #{@location.root}") 
    abort if ask_input("ok?[Y/n]").downcase == "n"
    save
  end

  private

  #
  # Open/Closed principle ... following methods are closed for modification
  #                           while aboves are open for it.
  #

  def articles(path)
    Dir["#{path}/*"]
      .select { |file| File.file?(file) && /\.md$/ =~ file }
  end

  def backup
    sys_git ([
      "cd #{@location.root}",
      "cp -r #{@location.raw}/* #{@location.pages}",
    ].join(";"))
  end

  def convert_raw(file)
    content = read(file).join
    content.gsub!(/(#{@location.pages}|#{@location.raw}|#{@location.root})\//, "")
    overwrite(file, content)    
  end

  def convert_page(file)
    content = read(file).map { |line|
      image_regex =~ line ? embedded_image_link(line) : line
    }
    overwrite(file, content)
  end

  def list_matches(file)
    puts "\n[file] " + file.gsub("#{@location.raw}/", "").gsub(".md", "")
    Terminal
      .new(interactive: false, key_words: Argument.new.values)
      .list(read.select{ |line| @regex.match?(line) })
      .paint
      .puts
  end

  def overwrite(file, content)
    f = File.open(File.join(pages, File.basename(file)), "w")
    f.puts content
    f.close
  end

  def sys_git(commands)
    if @debug 
      commands
    else
      system "#{commands}"
      system "echo \"#{commands}\" | pbcopy"
    end  
  end

  def sys_edit(file)
    if @debug
      return "#{file.strip}"
    else
      system "vim #{file}"
    end
  end
end