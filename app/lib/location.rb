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

  def etc
    File.join(@root, "etc")
  end

  def raw
    File.join(@root, "raws")
  end

  def pages
    File.join(@root, "pages")
  end

  private

  #
  # (O)open/closed principle
  # 
end
