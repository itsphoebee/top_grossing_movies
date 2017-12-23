#CLI Controller
require_relative "../top_grossing_movies/scraper.rb"
require_relative "../top_grossing_movies/movie.rb"
require 'nokogiri'
require 'colorize'
require 'pry'

class CLI

  def call                                            #starts the program
    puts "*****************************************************************************************".colorize(:blue)
    puts "  Welcome! Here's a list of the top 50 highest grossing movies worldwide as of 2016!".colorize(:color =>:black, :background => :yellow)
    puts "*****************************************************************************************".colorize(:blue)
    make_movies
    list_movies
    menu
  end

  def make_movies                                     #putting everything together
    scraped_movies = Scraper.scrape_movies            #call Scraper's scrape movie method to receive hash
    Movie.create_from_array(scraped_movies)           #use that hash to create new movies
  end

  def list_movies
    Movie.all.sort_by{|movie|movie.rank}.each do |movie|
      puts "#{movie.rank}. #{movie.name} (#{movie.release_year}) - $#{movie.sales.to_s.reverse.gsub(/(\d{3})/,"\\1,").chomp(",").reverse}"
    end
  end

  def list_by_year
    puts "Which year do you want to see?"
    input = gets.strip.to_i
    count = 0
    Movie.all.select do |movie|
      if movie.release_year == input
        count += 1
        puts "#{movie.name} ranks ##{movie.rank} on the list"
      end
    end
    puts "There is/are #{count} movie(s) from that year that made the list."
    more
  end

  def menu
    puts "Which movie would you like more info on? Input a number (1-50) " .colorize(:green)
    puts "Or if you want to see if there are top grossing movies in a certain year, please type 'search year'".colorize(:green)
    puts "Or type 'exit' to quit.".colorize(:green)
    input = gets.strip.downcase
    if input == 'exit'
      goodbye
    elsif input == 'search year'
      list_by_year
    elsif input.to_i > 50 || input.to_i <= 0
      puts "Invalid answer. Please enter an acceptable answer to type 'exit' to quit.".colorize(:red)
      menu
    else
      movie = Movie.find(input.to_i)
      display_movie(movie)
    end
  end

  def display_synopsis(movie)
    puts "Do you want to see the plot summary? y/n".colorize(:green)
    input = gets.strip
    case input
    when "y"
      movie.add_movie_attributes
      puts "Synopsis: #{movie.synopsis}"
    else
      puts "Okay. Let's move on."
    end
  end

  def display_movie(movie)
    puts "*********************************** #{movie.name.upcase} ***************************************".colorize(:yellow)
    puts "#{movie.name} had a gross box office sales of $#{movie.sales.to_s.reverse.gsub(/(\d{3})/,"\\1,").chomp(",").reverse} worldwide."
    puts "It was released in #{movie.release_year} and ranks ##{movie.rank} on the list out of 50."
    puts "It is considered a(n) #{movie.genre} movie and has an MPAA rating of #{movie.rating}."
    puts "Its total runtime is #{movie.runtime}s long."
    if movie.imdb_rating >7.0
      puts "IMDB rates this movie #{movie.imdb_rating}."
      puts "That's pretty good! Maybe you should check this movie out.".colorize(:blue)
      display_synopsis(movie)
    else
      puts "However, IMDB only rates this movie #{movie.imdb_rating}."
      puts "Maybe you should pass on watching this one.".colorize(:red)
      display_synopsis(movie)
    end
    puts "*****************************************************************************************".colorize(:yellow)
    more
  end

  def goodbye
    puts "See you next time!".colorize(:blue)
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
    else
      puts "I don't know what you mean."
      more
    end
  end

end
