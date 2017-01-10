require 'pry'
require_relative 'unknown_data_error'
class EconomicProfile
  attr_reader :identifier
  def initialize(identifier)
    @identifier = identifier
  end

  def median_household_income_in_year(year)
    raise(UnknownDataError) unless check_year_in_any_range(year)
    find_average_for_year(year)
    keys = keys.reject { |key| !key.include?(year) }
    @identifier[:median_household_income][keys.first]
  end

  def check_year_in_any_range(year)
    years = @identifier[:median_household_income].keys
    true_or_false = years.map { |range| year >= range[0] && year <= range[1] }
    true_or_false.any? { |boolean| boolean == true }
  end

  def check_year_in_a_range(year, range)
    year >= range[0] && year <= range[1]
  end

  def find_ranges_for_year(year)
    all_ranges = @identifier[:median_household_income].keys
    selected = all_ranges.reject do |range|
      !check_year_in_a_range(year, range)
    end
  end

  def find_salary_in_range(range)
    if range.flatten.count == 2
      find_average_for_range(range)
    else
      salaries = range.map { |range| find_average_for_range(range) }
      find_average(salaries)
    end
  end

  def median_household_income_average
    years = @identifier[:median_household_income].keys.flatten
    incomes = years.map { |year| median_household_income_in_year(year) }
    find_average(incomes)
  end

  def find_average_for_range(range)
    @identifier[:median_household_income][range]
  end

  def find_average(data)
    (data.reduce(:+) / data.count).to_i
  end
end
