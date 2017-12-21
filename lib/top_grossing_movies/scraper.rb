require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def scrape_movies
binding.pry
    doc = Nokogiri::HTML(open("http://www.imdb.com/list/ls000021718/"))
    scraped_movies = []
    doc.css("td").each do |movie|
      scraped_movies << {
        :name => movie.css("h3 a").text,
        :release_year => doc.css("span.lister-item-year.text-muted.unbold").text
        :rating =>doc.css("span.certificate").text
        :sales => d.css("div.list-description p").text[87..-1] #wip
        :runtime => d.css("span.runtime").text
        :genre => d.css("span.genre").text.gsub("\n", " ")
      }
    end
    scraped_movies
  end

end
