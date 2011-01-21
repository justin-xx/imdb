require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "IMDB::Search with multiple search results" do
  
  before(:each) do
    @search = IMDB::Search.new("Star Trek")
  end

  it "should remember the query" do
    @search.query.should == "Star Trek"
  end
  
  it "should find > 10 results" do
    @search.movies.size.should > 10
  end
  
  it "should return IMDB::Movie objects only" do
    @search.movies.each { |movie| movie.should be_an(IMDB::Movie) }
  end
  
  it "should not return movies with no title" do
    @search.movies.each { |movie| movie.title.should_not be_blank }
  end
  
end

describe "IMDB::Search with an exact match and no poster" do
  
  it "should not raise an exception" do
    lambda {
      @search = IMDB::Search.new("Kannethirey Thondrinal").movies
    }.should_not raise_error
  end
  
  it "should return the movie id correctly" do
    @search = IMDB::Search.new("Kannethirey Thondrinal")
    @search.movies.first.id.should eql("0330508")
  end
  
end

describe "IMDB::Search with an exact match" do
  
  before(:each) do
    @search = IMDB::Search.new("Matrix Revolutions")
  end
  
  it "should find one result" do
    @search.movies.size.should eql(1)
  end
  
  it "should have the corrected title" do
    @search.movies.first.title.should =~ /The Matrix Revolutions/i
  end
end
