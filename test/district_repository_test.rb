require_relative 'test_helper'
require './lib/district'
require './lib/district_repository'
require 'csv'

class DistrictRepositoryTest < Minitest::Test
  attr_reader :dr, :sample_data
  def setup
    @dr = DistrictRepository.new
  end

  def load
    @sample_data = CSV.open("kindergarten_sample_data.csv")
  end

  def test_it_a_district_repo
    assert dr
    assert_equal DistrictRepository, dr.class
  end

  def test_empty_districts_by_default
    assert dr.districts
    assert_equal Hash, dr.districts.class
    assert dr.districts.empty?
  end

  def test_sample_data_names_are_in_districts_keys
    dr.load_data({:enrollment => {:kindergarten => './test/Kindergarten_sample_data.csv'}})
    assert_equal 6, dr.districts.count
    names = ["ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J", "AGATE 300", "BENNETT 29J", "YUMA SCHOOL DISTRICT 1"]
    assert_equal names.sort, dr.districts.keys.sort
  end

  def test_can_find_district_by_name
    skip
    dr.load_data({:enrollment => {:kindergarten => './test/Kindergarten_sample_data.csv'}})
    result = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", result.name
    assert_equal District, result.class
  end

  def test_can_find_district_by_name_case_insensitive
    skip
    dr.load_data({:enrollment => {:kindergarten => './test/Kindergarten_sample_data.csv'}})
    result = dr.find_by_name("acaDEmy 20")
    assert_equal "ACADEMY 20", result.name
    assert_equal District, result.class
  end

  def test_find_by_all_returns_nil_for_no_search_results
    skip
    dr.load_data({:enrollment => {:kindergarten => './test/Kindergarten_sample_data.csv'}})
    result = dr.find_by_name("Turing School")
    assert_equal nil, result
  end

  def test_can_return_all_matching_from_find_all_matching_search
    skip
    dr.load_data({:enrollment => {:kindergarten => './test/Kindergarten_sample_data.csv'}})
    result_1 = []
    expected_1 = dr.find_all_matching("Tur")
    result_2_names = ["ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    expected_2 = dr.find_all_matching("ADA")
    assert_equal result_1, expected_1
    assert_equal result_2_names.sort, expected_2.sort
    assert_equal 2, expected_2.count
  end

  def test_find_all_returns_matching_from_case_insensitive_search
    skip
    dr.load_data({:enrollment => {:kindergarten => './test/Kindergarten_sample_data.csv'}})
    result_names = ["ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J"]
    expected = dr.find_all_matching("ada")
    assert_equal result_names.sort, expected.sort
    assert_equal 2, expected.count
  end
end
