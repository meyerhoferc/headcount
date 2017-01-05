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
    participation = @identifier[:kindergarten_participation][year]
    # binding.pry
    participation.to_f
  end

  def name
    @identifier[:name]
  end
end
