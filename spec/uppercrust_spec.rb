require "uppercrust"

spec_dir = File.expand_path(File.dirname(__FILE__))

describe Uppercrust::Generator do
  
  it "generates .h and .m files" do
    Uppercrust::Generator.generate(spec_dir, true)
  end
  
end