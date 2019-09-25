class Location
  #
  # (S)SRP        ... this class is responsible for the location of the app resources
  # Encapsulation ... This class is encapsulated as "location (of resources)" 

  attr_reader :root

  def initialize(root: "/usr/local")
    @application_name = "vol"
    @root             = root
  end

  def config
    "#{etc}/.config"
  end

  def etc
    File.join(@root, "etc", @application_name)
  end

  def raw
    "#{etc}/raw"
  end

  def raw_images
    "#{raw}/images"
  end

  def pages
    "#{etc}/pages"
  end

  def pages_images
    "#{pages}/images"
  end
end

