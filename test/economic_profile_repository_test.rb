require_relative 'test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repository'
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
  	#I think we called ep repo hash profiles, check
  end

  def test_can_load_data
  	assert epr.profiles.empty?
  	epr.load_data({ ##this is wrong, full file, need to grab the test fixtures files
  :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"
  }
})
  	assert_equal 4, str.profiles.count
  	names = []
  	assert_equal names.sort, epr.profiles.keys.sort
  end

  def test_can_grab_ep_by_name

  	assert_nil epr.find_by_name('CRAZY NAME')
  end

  def test_can_grab_data_from_ep_object
  end


  def test_can_load_total_data
  	epr.load_data({ :economic_profile => {
    	:median_household_income => "./data/Median household income.csv",
    	:children_in_poverty => "./data/School-aged children in poverty.csv",
    	:free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    	:title_i => "./data/Title I students.csv"
  	}})
  	end
end
