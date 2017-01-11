require_relative 'test_helper'
require './lib/economic_profile_repository'
require './lib/economic_profile'
require './lib/data_load'

class EconomicProfileRepositoryTest < Minitest::Test
  include DataLoad
  attr_reader :epr
  def setup
    @epr = EconomicProfileRepository.new
  end

  def test_it_is_an_economic_profile_repo
  	assert_equal EconomicProfileRepository, epr.class
  end

  def test_can_hold_a_collection_of_economic_profile_objects
  	assert_equal Hash, epr.profiles.class
  	assert epr.profiles.empty?
  end

  def test_can_load_data
  	assert epr.profiles.empty?
    epr.load_data({:economic_profile => {
      :median_household_income => "./test/fixtures/Median_household_income.csv",
      :children_in_poverty => "./test/fixtures/School_aged_children_in_poverty.csv",
      :free_or_reduced_price_lunch => "./test/fixtures/Students_qualifying_for_free_or_reduced_price_lunch.csv",
      :title_i => "./test/fixtures/Title_I_students.csv"
    }})
  	assert_equal 4, epr.profiles.count
  	names = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14', 'ADAMS-ARAPAHOE 28J']
  	assert_equal names.sort, epr.profiles.keys.sort
  end

  def test_can_grab_ep_by_name
    epr.load_data({:economic_profile => {
      :median_household_income => "./test/fixtures/Median_household_income.csv",
      :children_in_poverty => "./test/fixtures/School_aged_children_in_poverty.csv",
      :free_or_reduced_price_lunch => "./test/fixtures/Students_qualifying_for_free_or_reduced_price_lunch.csv",
      :title_i => "./test/fixtures/Title_I_students.csv"
    }})
    assert_equal 'ACADEMY 20', epr.find_by_name('ACADEMY 20').name
    assert_equal EconomicProfile, epr.find_by_name('ACADEMY 20').class
    assert_equal 'ADAMS COUNTY 14', epr.find_by_name('aDaMs coUntY 14').name
  	assert_nil epr.find_by_name('CRAZY NAME')
  end

  def test_can_grab_data_from_ep_object
    epr.load_data({:economic_profile => {
      :median_household_income => "./test/fixtures/Median_household_income.csv",
      :children_in_poverty => "./test/fixtures/School_aged_children_in_poverty.csv",
      :free_or_reduced_price_lunch => "./test/fixtures/Students_qualifying_for_free_or_reduced_price_lunch.csv",
      :title_i => "./test/fixtures/Title_I_students.csv"
    }})
    ep = epr.find_by_name('ACADEMY 20')
    assert_equal 87635, ep.median_household_income_in_year(2009)
  end

  def test_can_load_total_data
    skip 
  	epr.load_data({ :economic_profile => {
    	:median_household_income => "./data/Median household income.csv",
    	:children_in_poverty => "./data/School-aged children in poverty.csv",
    	:free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    	:title_i => "./data/Title I students.csv"
  	}})
  	end
end
