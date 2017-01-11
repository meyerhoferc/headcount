require 'pry'
require_relative 'unknown_data_error'
class EconomicProfile
  attr_reader :identifier
  def initialize(identifier)
    @identifier = identifier
  end

  def name
    @identifier[:name]
  end

  def median_household_income_in_year(year)
    raise(UnknownDataError) unless check_year_in_any_range(year)
    ranges = find_ranges_for_year(year)
    find_salary_in_range(ranges)
  end

  def check_year_in_any_range(year)
    years = @identifier[:median_household_income].keys
    true_or_false = years.map { |range| check_year_in_a_range(year, range) }
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
      find_average_for_range(range.flatten)
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

  def children_in_poverty_in_year(year)
    raise(UnknownDataError) unless @identifier[:children_in_poverty].has_key?(year)
    @identifier[:children_in_poverty][year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise(UnknownDataError) unless @identifier[:free_or_reduced_price_lunch].has_key?(year)
    @identifier[:free_or_reduced_price_lunch][year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise(UnknownDataError) unless @identifier[:free_or_reduced_price_lunch].has_key?(year)
    @identifier[:free_or_reduced_price_lunch][year][:total]
  end

  def title_i_in_year(year)
    raise(UnknownDataError) unless @identifier[:title_i].has_key?(year)
    @identifier[:title_i][year]
  end
end
