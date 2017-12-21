require_relative "../top_grossing_movies/movie.rb"
require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def scrape_movies
    doc = Nokogiri::HTML(open("http://www.imdb.com/list/ls000021718/?sort=list_order,asc&st_dt=&mode=detail&page=1&ref_=ttls_vm_dtl"))
    scraped_movies = []
    doc.css("div.lister-item.mode-detail").each do |movie|
      scraped_movies << {
        :name=> movie.css("h3 a").map(&:text),
        :release_year => movie.css("span.lister-item-year.text-muted.unbold").map(&:text),
        :rating =>movie.css("span.certificate").map(&:text),
        :sales => movie.css("div.list-description p").map(&:text),
        :runtime => movie.css("span.runtime").map(&:text)
      }
        end
    scraped_movies
  end

  def make_movies
    Movie.create_from_hash(scraped_movies)
  end

end
