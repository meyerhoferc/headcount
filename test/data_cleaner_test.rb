require_relative 'test_helper'
require "./lib/data_cleaner"

class DataCleanerTest < Minitest::Test
	include DataCleaner

	def test_it_can_clean_year
	  given = ["200", "2007", "02010", "20120", "2017"]
      result = [2000, 2007, 2010, 2012, 2017]
      matchers = given.zip(result)
      matchers.each { |pair| assert_equal pair[1], clean_year(pair[0]) }
	end

	def test_it_can_clean_range
	  raw_range = "2005-2009"
      expected = [2005, 2009]
      assert_equal expected, clean_range(raw_range)
      assert_equal Array, clean_range(raw_range).class

	end

	def test_it_can_clean_percentages
	  given =  ["0", "1", "0.12345", "N/A", "0.123", "LNE", "#VALUE!"]
      result = [0, 1.000, 0.123, "N/A", 0.123,"LNE", "#VALUE!"]
      matching = given.zip(result)
      matching.each { |pair| assert_equal pair[1], clean_percent(pair[0]) }

	end

	def test_it_can_clean_salary
	  salaries = ["55000", "56298", "89123"]
      salaries.each { |salary| assert_equal Fixnum, clean_salary(salary).class }
	end
end
