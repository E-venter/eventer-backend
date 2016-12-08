require 'rake/file_utils'
class FileManager
  class << self
    def save_file(temp_file, filename)
      FileUtils.cp(temp_file.path, filename)
    end
  end
end