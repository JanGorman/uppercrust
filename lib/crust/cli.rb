require 'thor'
require 'crust'

module Crust
  class CLI < Thor

    desc 'generate', 'Generates the Objective-C file(s)'
    method_options :path => :string, :base_only => :boolean

    def generate
      puts Crust::Generator.generate(options[:path], options[:base_only])
    end

  end
end