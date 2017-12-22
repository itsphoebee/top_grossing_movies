require 'pry'
class Movie
  attr_accessor :name, :release_year, :sales, :rating, :runtime, :rank
  @@all = []

  def initialize(hash)            #receive a hash of attributes to create a new instance of movie
    hash.each {|key, value| self.send(("#{key}="), value)}    #each key and value gets pushed into instance of self
    @@all << self                   # add to all movies array to store
  end

  def self.create_from_hash(movies_list)
    movies_list.each do |movie| movie = self.new(movie)         #create a new movie based on array list
    end
  end

  def self.all            #call array of stored movies
    @@all
  end

  def self.find(n)    #look into @@all and find movie with rank number n and return that movie
    self.all.detect {|movie|
      movie.rank == n.to_i}
  end

  def add_movie_attributes(hash)
    hash.each {|key, value| self.send(("#{key}="), value)} 
  end

end
