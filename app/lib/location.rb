class Location
  #
  # (S)SRP        ... this class is responsible for the location of the app resources
  # Encapsulation ... This class is encapsulated as "location (of resources)" 

  def initialize(root: nil)
    #
    # variable initialization
    #
    @application_name = "vol"
    @root             = root || "/usr/local"
  end

  def config
    File.join(etc, @application_name, ".config")
  end

  def etc
    File.join(@root, "etc", @application_name)
  end

  def raw
    File.join(etc, "raw")
  end

  #
  # XXX test
  #
  def raw_images
    File.join(raw, "images")
  end

  def pages
    File.join(etc, "pages")
  end

  #
  # XXX test
  #
  def pages_images
    File.join(pages, "images")
  end
end
