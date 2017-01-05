require 'pry'

class Enrollment
  attr_reader :identifier
  def initialize(identifier)
    @identifier = identifier
  end

  def kindergarten_participation_by_year
    @identifier[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    @identifier[:kindergarten_participation][year]
  end

  def name
    @identifier[:name]
  end
end
