require 'pry'
class Movie
  attr_accessor :name, :release_year, :sales, :rating, :runtime, :genre
  binding.pry
  def initialize(name)
    @name = name
  end

end
