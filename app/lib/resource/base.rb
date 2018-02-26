module Resource
  class Base
    def initialize(resources: [], location:)
      @resource_files = resource_files(resources)
      @location       = location
      @pages_files    = []
    end

    def append_sys_command
      @resource_files.map do |file|
        copy(file, "#{Time.now.strftime("%s%6N")}#{File.extname(file)}")
      end
      "echo \"#{resource_string}\" | pbcopy"
    end

    private

    def copy(file, file_name)
      FileUtils.cp(file, File.join(@location.raw_images, file_name))
      pages_file = File.join(@location.pages_images, file_name)
      FileUtils.cp(file, pages_file)
      @pages_files.push(pages_file)
    end

    def resource_files(resources)
      resources
        .select { |file| File.exist?(file) }
        .map    { |file| File.file?(file) ? file : Dir["#{file}/**/*"] }
        .flatten
    end

    def resource_string
      @pages_files.map { |file| "![image](#{file})" }.join("\n")
    end
  end
end
