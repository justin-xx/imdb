module Imdb
  
  # Represents a Movie on IMDB.com
  class Movie
    attr_accessor :id, :url, :title
    
    # Initialize a new IMDB movie object with it's IMDB id (as a String)
    #
    #   movie = Imdb::Movie.new("0095016")
    #
    # Imdb::Movie objects are lazy loading, meaning that no HTTP request
    # will be performed when a new object is created. Only when you use an 
    # accessor that needs the remote data, a HTTP request is made (once).
    #
    def initialize(imdb_id, title = nil)
      @id = imdb_id
      @url = "http://www.imdb.com/title/tt#{imdb_id}/"
      @title = title.gsub(/"/, "") if title
    end

    def credits
      raw_credits = (document/'table[@cellspacing="1"]')

      raw_credits.inject({}) do |parsed_credits, result|
        parsed_credits << case result.inner_text    
        when /^Directed by.*/i, /Makeup/, /Art/
          nil
        when /^(Writing credits\s*)(.*)/i
          {:written_by => $2.gsub(/\(written by\)/, '').gsub(/\s*and\s*/, ',').gsub(/^\(WGA\)\s*/, '').strip}
        when /^(Cinematography by\s*)(.*)/i
          {:cinematographer => $2.gsub(/\(director of photography\)/, '').gsub(/\s*and\s*/, ', ').strip}
        else
          nil
        end
      end            
    end
    
    private
    
    # Returns a new Hpricot document for parsing.
    def document
      @document ||= Hpricot(Imdb::Movie.find_by_id(@id))
    end
    
    # Use HTTParty to fetch the raw HTML for this movie.  
    def self.find_by_id(imdb_id)
      open("http://www.imdb.com/title/tt#{imdb_id}/fullcredits")      
    end
    
    # Convenience method for search
    def self.search(query)
      Imdb::Search.new(query).movies
    end    
  end # Movie
end # Imdb