require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "IMDB" do
  
  it "should report the right version" do
    current_version = File.open(File.join(File.dirname(__FILE__), '..', '..', 'VERSION'), 'r') { |f| f.read.strip }
    IMDB::VERSION.should eql(current_version)
  end
  
end