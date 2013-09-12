require 'crust/version'
require 'crust/generate'

require 'json'

module Crust
  class Generator

    def self.generate(path, base_only)
      if File.readable?(path)

        files = read_files(path, base_only)

        if files.length > 0
          FileUtils.mkdir('output')

          output = []

          files.each do |generate|
            puts "Generate #{generate.file_name}"
            output << generate.generate_files
          end

          output.each do |generated|
            generated.each { |name, contents| File.open(File.join('output', name), 'w') { |f| f.write(contents) } }
          end
        end

      else
        puts "Cannot read path #{path}"
      end
    end

    private

    def self.read_files(path, base_only)
      files = File.file?(File.absolute_path(path)) ? [File.absolute_path(path)] : Dir.glob(File.join(File.absolute_path(path), '**', '*.json'))

      output = []
      files.each do |json_file|
        data = JSON.parse(File.open(json_file, 'r') { |f| f.read })
        output << Generate.new(json_file, data, base_only)
      end
      output
    end

  end
end
