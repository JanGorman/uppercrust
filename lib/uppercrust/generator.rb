require 'mustache'
require 'json'
require 'uppercrust/parser'

module Uppercrust

  class Generator
    
    def self.generate(path, base_only)
      unless File.readable?(path)
        puts "Cannot read path #{path}"
        return
      end

      files = read_files(path, base_only)
      if files.length > 0
        FileUtils.mkdir("output")
        output = []
        files.each do |generate|
          puts "Generate #{generate.file_name}"
          output << generate.generate_files
        end
        output.each do |generated|
          generated.each { |name, contents| File.open(File.join("output", name), "w") { |f| f.write(contents) } }
        end
      end
    end

    def self.read_files(path, base_only)
      files = File.file?(File.absolute_path(path)) ? [File.absolute_path(path)] : glob_dir_for_json(path)

      output = []
      files.each do |json_file|
        data = JSON.parse(File.open(json_file, 'r') { |f| f.read })
        output << Parser.new(json_file, data, base_only)
      end
      output
    end

    def self.glob_dir_for_json(path)
      Dir.glob(File.join(File.absolute_path(path), '**', '*.json'))
    end

  end

end