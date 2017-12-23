#CLI Controller
require_relative "../top_grossing_movies/scraper.rb"
require_relative "../top_grossing_movies/movie.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class CLI

  def make_movies                                     #putting everything together
    scraped_movies = Scraper.scrape_movies            #call Scraper's scrape movie method to receive hash
    Movie.create_from_array(scraped_movies)           #use that hash to create new movies
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

  def add_movie_synopsis
    Movie.all.each do |movie|
      synopsis = Scraper.movie_profile(movie.movie_profile)
      movie.add_movie_attributes(synopsis)
    end
  end

  def display_movie(movie)
    add_movie_synopsis
    puts "*********************************** #{movie.name.upcase} ***************************************".colorize(:yellow)
    puts "#{movie.name} had a gross box office sales of $#{movie.sales.to_s.reverse.gsub(/(\d{3})/,"\\1,").chomp(",").reverse} worldwide."
    puts "It was released in #{movie.release_year} and currently ranks ##{movie.rank} on the list out of 50."
    puts "It is considered a(n) #{movie.genre.downcase} movie and has an MPAA rating of #{movie.rating}."
    puts "Its total runtime is #{movie.runtime}s long."
    puts "The movie is about: #{movie.synopsis}"
    puts "*****************************************************************************************".colorize(:yellow)
    menu
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

  def call
    puts "***************************************************************************".colorize(:blue)
    puts "  Welcome! Here's a list of the top 50 highest grossing movies worldwide!".colorize(:color =>:black, :background => :yellow)
    puts "***************************************************************************".colorize(:blue)
    make_movies
    list_movies
    menu
  end

end
