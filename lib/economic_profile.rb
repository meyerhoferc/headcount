require 'pry'
require_relative 'unknown_data_error'
class EconomicProfile
  attr_reader :identifier
  def initialize(identifier)
    @identifier = identifier
  end

  def median_household_income_in_year(year)
    keys = @identifier[:median_household_income].keys
    raise(UnknownDataError) unless keys.any? { |key| key.include?(year) }
    keys = keys.reject { |key| !key.include?(year) }
    @identifier[:median_household_income][keys.first]
  end

  def median_household_income_average
    years = @identifier[:median_household_income].keys.flatten
    incomes = years.map { |year| median_household_income_in_year(year) }
    find_average(incomes)
  end

  def find_average(data)
    (data.reduce(:+) / data.count).to_i
  end
end
