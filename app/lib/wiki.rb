class Wiki
  attr_reader :original_articles, :formatted_articles
  #
  # SRP ... all wiki files/contents are `encapsulated` into a object `wiki`
  #
  def initialize(location)
    @location           = location
    @original_articles  = get_markdowns_only(@location.raw)
    @formatted_articles = get_markdowns_only(@location.pages)
  end

  private
  #
  # Open/Closed principle ... following methods are closed for modification
  #                           while aboves are open for it.
  #

  def articles(path)
    Dir["#{path}/*"]
  end

  def get_markdowns_only(path)
    articles(path).select { |file| /\.md/ =~ file }
  end
end
