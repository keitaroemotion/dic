class Wiki
  attr_reader :original_articles, :formatted_articles
  #
  # SRP ... all wiki files/contents are `encapsulated` into a object `wiki`
  #
  def initialize(location)
    @location           = location
    @editor             = "vim"
    @original_articles  = articles(@location.raw)
    @formatted_articles = articles(@location.pages)
  end

  #
  # XXX test
  #
  def save
    system ([
      "cd #{@location.root}",
      "git add #{@location.root}",
      "git commit -m \"page updated\"",
      "git pull origin master",
      "git push origin master",
    ].join(";"))
  end

  #
  # XXX test
  #
  def update
    @wiki.original_articles.each { |file| convert_raw(file) }
    backup
    @wiki.formatted_articles.each { |file| convert_page(file) }
    system ("cd #{@root}; git --no-pager diff #{@location.root}") 
    abort if ask_input("ok?[Y/n]").downcase == "n"
    save
  end

  #
  # XXX test
  #
  def create(args)
    system "#{@editor} #{@location.raw}/#{args.join('_')}.md"
  end

  #
  # XXX test
  # 
  def edit(files, size)
    size = 1 unless size < files.size
    system "#{@editor} #{files[size - 1]}"
  end

  def self.get(input, files)
    file_index = input.strip.size - 1
    file_index = 0 unless file_index < files.size
    files[file_index]
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

  def convert_raw(file)
    content = File.read(file)
    content.gsub!(/(#{@location.pages}|#{@location.raw}|#{@location.root})\//, "")
    overwrite(file, content)    
  end

  def convert_page(file)
    content = File.read(file).split("\n").map { |line|
      image_regex =~ line ? embedded_image_link(line) : line
    }
    overwrite(file, content)
  end

  def backup
    system ([
      "cd #{@location.root}",
      "cp -r #{@location.raw}/* #{@location.pages}",
    ].join(";"))
  end

  def overwrite(file, content)
    f = File.open(File.join(pages, File.basename(file)), "w")
    f.puts content
    f.close
  end
end
