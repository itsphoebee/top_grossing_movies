require 'pry'
class Movie
  attr_accessor :name, :release_year, :sales, :rating, :runtime, :genre, :rank
  @@all = []

  def initialize(hash)
    hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_hash(movies_list)
    movies_list.each do |movie| movie = self.new(movie)
  end

  def self.all
    @@all
  end
end
