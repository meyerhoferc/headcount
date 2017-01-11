require_relative 'test_helper'
require './lib/economic_profile'
require './lib/data_load'

class EconomicProfileTest < Minitest::Test
  attr_reader :ep
  def setup
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
    @ep = EconomicProfile.new(data)
  end

  def test_it_is_a_economic_profile
    assert_equal EconomicProfile, ep.class
  end

  def test_it_has_an_identifier_hash_and_has_keys
    assert_equal Hash, ep.identifier.class
    keys = [:median_household_income, :children_in_poverty,
      :free_or_reduced_price_lunch, :title_i, :name]
    keys.each { |key| assert ep.identifier.keys.include?(key) }
  end

  def test_it_can_return_name
    assert_equal 'ACADEMY 20', ep.name
  end

  def test_knows_if_year_is_in_range_of_a_key
    years = [2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014]
    years.each { |year| assert ep.check_year_in_any_range(year) }
    not_years = [2004, 2076, 1990, 2080, 2001, 3000]
    not_years.each { |year| refute ep.check_year_in_any_range(year) }
  end

  def test_can_find_range_or_ranges_year_fits_into
    range_1 = [2005, 2009]
    range_2 = [2008, 2014]

    assert_equal [range_1], ep.find_ranges_for_year(2005)
    assert_equal [range_1], ep.find_ranges_for_year(2006)
    assert_equal [range_1, range_2], ep.find_ranges_for_year(2008)
    assert_equal [range_2], ep.find_ranges_for_year(2010)
    assert_equal [range_2], ep.find_ranges_for_year(2014)
    assert_equal [range_1, range_2], ep.find_ranges_for_year(2009)
  end

  def test_can_find_salary_for_year_range
    full_range = [[2005, 2009], [2008, 2014]]
    range_1, range_2 = full_range
    actual_1, actual_2, actual_3 = [50000, 60000, 55000]
    assert_equal actual_1, ep.find_salary_in_range(range_1)
    assert_equal actual_2, ep.find_salary_in_range(range_2)
    assert_equal actual_3, ep.find_salary_in_range(full_range)
  end

  def test_returns_median_household_income
    actual_1 = ep.median_household_income_in_year(2005)
    actual_2 = ep.median_household_income_in_year(2014)
    actual_4 = ep.median_household_income_in_year(2008)
    actual_5 = ep.median_household_income_in_year(2007)
    assert_equal 50000, actual_1
    assert_equal 60000, actual_2
    assert_equal 55000, actual_4
    assert_equal 50000, actual_5
    assert_equal Fixnum, actual_1.class
    assert_equal Fixnum, actual_2.class
    assert_raises(UnknownDataError) { ep.median_household_income_in_year(2075) }
  end

  def test_returns_average_median_household_income
    actual = ep.median_household_income_average
    assert_equal 55000, actual
    assert_equal Fixnum, actual.class
  end

  def test_returns_percentage_of_children_in_poverty
    actual_2 = ep.children_in_poverty_in_year(2012)
    assert_raises(UnknownDataError) { ep.children_in_poverty_in_year(2009) }
    assert_equal Float, actual_2.class
    assert_equal 0.1845, actual_2
  end

  def test_returns_percentage_of_free_reduced_lunch
    actual_1 = ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    assert_raises(UnknownDataError) { ep.free_or_reduced_price_lunch_percentage_in_year(2004) }
    assert_equal 0.023, actual_1
  end

  def test_returns_number_of_free_reduced_lunch
    actual_1 = ep.free_or_reduced_price_lunch_number_in_year(2014)
    assert_raises(UnknownDataError) { ep.free_or_reduced_price_lunch_number_in_year(2088) }
    assert_equal 100, actual_1
  end

  def test_returns_data_for_return_title_i_in_year
    assert_equal 0.543, ep.title_i_in_year(2015)
    assert_raises(UnknownDataError) { ep.title_i_in_year(2000) }
  end
end
