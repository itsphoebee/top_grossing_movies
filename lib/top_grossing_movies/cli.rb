#CLI Controller
require_relative "../top_grossing_movies/scraper.rb"
require_relative "../top_grossing_movies/movie.rb"
require 'nokogiri'
require 'pry'

class CLI

  def call
    puts "Welcome! Here is a list of the top grossing movies worldwide!"
    list_movies
    menu
  end

  def list_movies
    Movie.all.each_with_index {|movie,index|
      puts "#{movie.index+1}. #{movie.name} - #{movie.sales}"}
  end

  def menu
    puts "Which movie would you like more info on? Input a number or type 'exit' to quit."
    input = gets.strip.downcase
    case input
    when "1"
        puts "Movie Name: Avatar"
        puts "Year Released: 2009"
        puts "Worldwide Box Office Sales: $2,058,662,225"
        puts "Production Budget: $425,000,000"
        puts "MPAA Rating: PG-13"
        puts "Runtime: 162 Minutes"
        puts "Genre: Action"
        more
      when "exit"
        goodbye
      else
        puts "Please enter a number or type 'exit' to quit."
        menu
    end
  end

  def goodbye
    puts "See you next time!"
    exit
  end

  def more
    puts "Would you like to see other movies? y/n"
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
