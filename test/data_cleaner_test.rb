require_relative 'test_helper'
require "./lib/data_cleaner"


class DataCleanerTest < Minitest::Test 
	include DataCleaner

	def test_it_can_clean_year
	  given = ["200", "2007", "02010", "20120", "2017"]
      result = [2000, 2007, 2010, 2012, 2017]
      matchers = given.zip(result)
      matchers.each { |pair| assert_equal pair[1], er.clean_year(pair[0]) }
      
	end

	def test_it_can_clean_range

	end

	def test_it_can_clean_percentages
	  given =  ["0", "1", "0.12345", "N/A", "0.123", "LNE", "#VALUE!"]
      result = [0.00000, 1.00000, 0.12345, "N/A", 0.12300,"LNE", "#VALUE!"]
      matching = given.zip(result)
      matching.each { |pair| assert_equal pair[1], er.clean_occupancy(pair[0]) }

	end

	def test_it_can_clean_salary

	end

	# def test_it_can_clean_tag
	# end

end
