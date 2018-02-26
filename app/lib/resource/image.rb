require "./app/lib/resource/base.rb"

module Resource
  class Image < Resource::Base
  def initialize(line, resources: [], location:)
    super
  end

  #
  # the purpose of this former part is forgotten. needs to be checked out
  #
  def embed
    @prefix ? "<img src=#{@prefix} #{/^\d*$/ =~ @postfix ? height : ""}/>" : @line
  end

  private

  def height
    "height=#{@postfix}"
  end

  def tokens
    tokens = /images\/.*(\.jpg|\.png|\.gif|\.jpeg|\.JPG)*[^\)]+/
      .match(@line)
      .to_s
      .gsub(")", "")
      .split(" ")
    @prefix  = tokens.first  
    @postfix = tokens.second
  end
 end 
end

