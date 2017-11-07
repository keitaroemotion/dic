require "./app/lib/resource/base.rb"

module Resource
  #
  # Inheritance ... Since the embedded resource on wiki markdown can be
  #                 diverse, it is abstractly defined as Resource::Base
  #
  # Polymorphism .. Resouce::Base is abstractly defined, then
  #                 it could be implemented into Image, Excel, PDF, etc..
  #
  class Image < Resource::Base
  #
  # SRP ... handles image only
  #
  def initialize(line, resource: nil)
    @prefix  = nil
    @postfix = nil
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

