require 'crust'
require 'json'

spec_dir = File.expand_path(File.dirname(__FILE__))

describe Crust::Generator do

  it 'generate crust' do
    Crust::Generator.generate(spec_dir, true)
  end

end