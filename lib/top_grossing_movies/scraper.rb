require_relative "../top_grossing_movies/movie.rb"
require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_movies # grab all the movies from imdb webpage list
    doc = Nokogiri::HTML(open("http://www.imdb.com/list/ls000021718/?sort=list_order,asc&st_dt=&mode=detail&page=1&ref_=ttls_vm_dtl"))    #html url
    scraped_movies = []         # create an array to store all the movies
    doc.css("div.lister-item.mode-detail").each do |movie|        #iterate through the content to pull
      scraped_movies << {                                     #add them into the movie array as a hash
        :rank => movie.css("span.lister-item-index.unbold.text-primary").text.gsub(/\D/,'').to_i, # movie's rank based on sales
        :name => movie.css("h3 a").text,                # movie needs a name
        :release_year => movie.css("span.lister-item-year.text-muted.unbold").text.gsub(/\D/,'').to_i, #year
        :rating => movie.css("span.certificate").text,        #rating
        :sales => movie.css("div.list-description p").text.gsub(/\D/,'').to_i,  # global box office sales
        :runtime => movie.css("span.runtime").text,           # how long the movie runs
        :movie_profile => movie.css("h3.lister-item-header a").attribute("href").value,
        :genre => movie.css("p.text-muted.text-small span.genre").text.gsub("\n","").strip
      }
      end
    scraped_movies                                          #return the array of hashes
  end

  def self.movie_profile(movie_profile)
    doc = Nokogiri::HTML(open("http://www.imdb.com#{movie_profile}"))
    scraped_profile = []
    doc.css("div.plot_summary").each do |profile|
      scraped_profile << {
        :synopsis => profile.css("div.summary_text").text.gsub("\n","").strip,
        :director => profile.css("div.summary_text").text.gsub("\n","").strip
        #WIP  --- :director => profile.css("span.director a span.itemprop").text
      }
    end
    scraped_profile
  end

end
