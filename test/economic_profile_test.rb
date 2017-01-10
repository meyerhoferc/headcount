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
    skip 
    assert_equal Hash, ep.identifier.class
    keys = [:median_household_income, :children_in_poverty,
      :free_or_reduced_price_lunch, :title_i, :name]
    keys.each { |key| assert ep.identifier.keys.include?(key) }
  end

  def test_has_no_repeats_of_values_inside_of_one_keys_hash
    skip
    keys = [:median_household_income, :children_in_poverty,
      :free_or_reduced_price_lunch, :title_i, :name]
    keys.each do |key|
      values =  ep.identifier[key].values
      tally = values.count do |value|
        value == value
      end
      assert_includes([0,  1], tally)
    end
    # no idea if this will work, use different enum
  end

  def test_returns_median_household_income
    skip
    actual_1 = ep.median_household_income_in_year(2005)
    actual_2 = ep.median_household_income_in_year(2014)
    actual_3 = ep.median_household_income_in_year(2075)
    assert_equal 50000, actual_1
    assert_equal 60000, actual_2
    assert_raises(UnknownDataError) { actual_3 }
  end

  def test_returns_average_median_household_income
    skip
    actual = ep.median_household_income_average
    assert_equal 55000, actual
  end

  def test_returns_percentage_of_children_in_poverty
    skip
    actual_1 = ep.children_in_poverty(2009)
    actual_2 = ep.children_in_poverty(2012)
    assert_raises(UnknownDataError) { actual_1 }
    assert_equal 0.1845, actual_2
  end

  def test_returns_percentage_of_free_reduced_lunch
    skip
    actual_1 = ep.free_or_reduced_price_lunch_percentage_in_year(2014)
    actual_2 = ep.free_or_reduced_price_lunch_percentage_in_year(2004)
    assert_raises(UnknownDataError) { actual_2 }
    assert_equal 0.023, actual_1
  end

  def test_returns_number_of_free_reduced_lunch
    skip
    actual_1 = ep.free_or_reduced_price_lunch_number_in_year(2014)
    actual_2 = ep.free_or_reduced_price_lunch_number_in_year(2088)
    assert_raises(UnknownDataError) { actual_2 }
    assert_equal 100, actual_1
  end
end
