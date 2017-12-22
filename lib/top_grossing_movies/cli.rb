#CLI Controller
require_relative "../top_grossing_movies/scraper.rb"
require_relative "../top_grossing_movies/movie.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class CLI

  def make_movies         #putting everything together
    scraped_movies = Scraper.scrape_movies      #call Scraper's scrape movie method to receive hash
    Movie.create_from_hash(scraped_movies)           #use that hash to create new movies
  end

  def display_movie(movie)
    puts "*********************************** #{movie.name.upcase} ***************************************".colorize(:yellow)
    puts "#{movie.name} had a gross box office sales of $#{movie.sales} worldwide."
    puts "It was released in #{movie.release_year} and currently ranks number #{movie.rank} on the list out of 50."
    puts "It has an MPAA rating of #{movie.rating}."
    puts "Its total runtime is #{movie.runtime}s long."
    puts "*****************************************************************************************".colorize(:yellow)
    menu
  end

  def call
    puts "***************************************************************************".colorize(:blue)
    puts "  Welcome! Here's a list of the top 50 highest grossing movies worldwide!".colorize(:color =>:black, :background => :yellow)
    puts "***************************************************************************".colorize(:blue)
    make_movies
    list_movies
    menu
  end

  def list_movies
    Movie.all.sort_by{|movie|movie.rank}.each do |movie|
      puts "#{movie.rank}. #{movie.name} (#{movie.release_year}) - $#{movie.sales.to_s.reverse.gsub(/(\d{3})/,"\\1,").chomp(",").reverse}"
    end
  end

  def menu
    puts "Which movie would you like more info on? Input a number or type 'exit' to quit.".colorize(:green)
    input = gets.strip.downcase
    if input == 'exit'
      goodbye
    elsif input.to_i > 50 || input.to_i <= 0
      puts "Invalid answer. Please enter an acceptable answer to type 'exit' to quit.".colorize(:red)
      menu
    else
      movie = Movie.find(input.to_i)
      display_movie(movie)
    end
  end

  def goodbye
    puts "See you next time!".colorize(:green)
    exit
  end

  def more
    puts "Would you like to see other movies? y/n".colorize(:green)
    input = gets.strip.downcase
    case input
    when "y"
      list_movies
      menu
    when "n"
      goodbye
    end
  end

end
