require "thor"
require "uppercrust"

module Uppercrust
  class CLI < Thor
    desc "generate files", "Generates .h and .m files from the given directory"
    option :path, :required => true, :aliases => '-p'
    option :base_only, :type => :boolean, :aliases => '-b'
    def generate
      puts Uppercrust::Generator.generate(options[:path], options[:base_only])
    end
  end
end