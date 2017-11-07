module Resource
  class Base
    #
    # Polymorphism: the following methods are common among all child resources
    # DIP ... Dependency Inversion Principle
    #         While child class rely on this Base class#attach,
    #         Base class itself NEVER refer to any methods or variables
    #         from any child nodes, ex. Image
    #         Since Resource#Base is abstract.
    #
    def initialize(line: "", resources: nil)
      @resource_files = resource_files(resources)
      @line      = line  
      @location  = Location.new
    end

    def attach
      @resource_files.map do |file|
        file_name = "#{uniq_prefix}#{File.extname(file)}"
        FileUtils.cp(file, raw_file(file_name))
        FileUtils.cp(file, pages_file(file_name))
      end
      system "echo \"#{resource_string}\" | pbcopy"
    end

    private

    def raw_file(file_name)
      File.join(@location.raw_images, file_name)
    end

    def pages_file(file_name)
      File.join(@location.pages_images, file_name)
    end

    def resource_files(resources)
      resources
        .map    { |file| puts "absent: #{file}" unless File.exist?(file); file }
        .select { |file| File.exist?(file) }
        .map    { |file| File.file?(file) ? file : Dir["#{file}/**/*"] }
        .flatten
    end

    def resource_string
      @resource_files.map { |file| "![image](#{pages_file(file)})" }.join("\n")
    end

    def uniq_prefix
      sleep 1
      t   = Time.now
      sec = t.to_s.gsub(/[\+\:\-\s]/, "")
      "#{t.year}#{t.month}#{t.day}#{sec}"
    end
  end
end
