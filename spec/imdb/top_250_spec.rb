require File.dirname(__FILE__) + "/../spec_helper"

describe IMDB::Top250 do
  before(:each) do
    @movies = IMDB::Top250.new.movies
  end
  
  it "should be a list of movies" do
    @movies.each { |movie| movie.should be_an_instance_of(IMDB::Movie) }
  end
  
  it "should return the top 250 movies from IMDB.com" do
    @movies.size.should == 250
  end

  it "should provide array like access to the movies" do
    @first = @movies.first
    @first.title.should == "The Shawshank Redemption"
    @first.genres.should include("Drama")
  end
end
