module IMDB

  class MovieList
    def movies
      @movies ||= parse_movies
    end
    
    private
    def parse_movies
      document.search('a[@href^="/title/tt"]').reject do |element|
        element.innerHTML.imdb_strip_tags.empty? ||
        element.parent.innerHTML =~ /media from/i
      end.map do |element|
        id = element['href'][/\d+/]
        
        data = element.parent.innerHTML.split("<br />")
        if !data[0].nil? && !data[1].nil? && data[0] =~ /img/
          title = data[1]
        else
          title = data[0]
        end
        
        title = title.imdb_strip_tags.imdb_unescape_html
        title.gsub!(/\s+\(\d\d\d\d\)$/, '')
        
        [id, title]
      end.uniq.map do |values|
        IMDB::Movie.new(*values)
      end
    end
  end # MovieList

end # IMDB
