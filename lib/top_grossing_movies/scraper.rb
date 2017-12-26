

class TopGrossingMovies::Scraper

  def self.scrape_movies                                                                          # grab all the movies from imdb webpage list
    doc = Nokogiri::HTML(open("http://www.imdb.com/list/ls000021718/"))    #html url
    doc.css("div.lister-item.mode-detail").each do |movie|                                        # iterate through the content to pull
      TopGrossingMovies::Movie.new({                                                                         # add them into the movie array as a hash
        :rank => movie.css("span.lister-item-index.unbold.text-primary").text.gsub(/\D/,'').to_i, # movie's rank based on sales
        :name => movie.css("h3 a").text,
        :release_year => movie.css("span.lister-item-year.text-muted.unbold").text.gsub(/\D/,'').to_i,
        :rating => movie.css("span.certificate").text,
        :sales => movie.css("div.list-description p").text.gsub(/\D/,'').to_i,
        :runtime => movie.css("span.runtime").text,
        :movie_profile => movie.css("h3.lister-item-header a").attribute("href").value,
        :genre => movie.css("p.text-muted.text-small span.genre").text.gsub("\n","").split(/[\s,]+/).join("/").downcase,
        :imdb_rating => movie.css("div.inline-block.ratings-imdb-rating strong").text.to_f
      })
    end                                                                      # return the array of hashes
  end

  def self.scrape_synopsis(movie_profile)
    doc = Nokogiri::HTML(open("http://www.imdb.com#{movie_profile}"))
    synopsis = doc.css("div.plot_summary div.summary_text").text.gsub("\n","").strip
  end
end
