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
        :name=> movie.css("h3 a").map(&:text),                # movie needs a name
        :release_year => movie.css("span.lister-item-year.text-muted.unbold").map(&:text), #year
        :rating =>movie.css("span.certificate").map(&:text),        #rating
        :sales => movie.css("div.list-description p").map(&:text),  # global box office sales
        :runtime => movie.css("span.runtime").map(&:text)           # how long the movie runs
      }
        end

    scraped_movies                                            #return the array of hashes
  end

end
