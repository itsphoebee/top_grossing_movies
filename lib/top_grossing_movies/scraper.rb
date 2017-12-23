require_relative "../top_grossing_movies/movie.rb"
require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_movies                                                                          # grab all the movies from imdb webpage list
    doc = Nokogiri::HTML(open("http://www.imdb.com/list/ls000021718/?sort=list_order,asc&st_dt=&mode=detail&page=1&ref_=ttls_vm_dtl"))    #html url
    scraped_movies = []                                                                           # create an array to store all the movies
    doc.css("div.lister-item.mode-detail").each do |movie|                                        # iterate through the content to pull
      scraped_movies << {                                                                         # add them into the movie array as a hash
        :rank => movie.css("span.lister-item-index.unbold.text-primary").text.gsub(/\D/,'').to_i, # movie's rank based on sales
        :name => movie.css("h3 a").text,
        :release_year => movie.css("span.lister-item-year.text-muted.unbold").text.gsub(/\D/,'').to_i,
        :rating => movie.css("span.certificate").text,
        :sales => movie.css("div.list-description p").text.gsub(/\D/,'').to_i,
        :runtime => movie.css("span.runtime").text,
        :movie_profile => movie.css("h3.lister-item-header a").attribute("href").value,
        :genre => movie.css("p.text-muted.text-small span.genre").text.gsub("\n","").strip,
        :imdb_rating => movie.css("div.inline-block.ratings-imdb-rating strong").text.to_f
      }
      end
    scraped_movies                                                                                # return the array of hashes
  end

  def self.movie_profile(movie_profile)                                                           # scrapes the movie synopsis after opening the movie's profile page
    doc = Nokogiri::HTML(open("http://www.imdb.com#{movie_profile}"))                             # couldn't scrape synopsis from previous page so had to build this method
    scraped_profile = {}                                                                          # create a hash to store the description
    doc.css("div.plot_summary").each do |profile|
      scraped_profile[:synopsis] = profile.css("div.summary_text").text.gsub("\n","").strip
    end
    scraped_profile
  end
  #binding.pry
end
