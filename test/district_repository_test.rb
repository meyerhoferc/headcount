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
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    assert_equal 27, dr.districts.count
    names = ["ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J", "AGATE 300",
      "BENNETT 29J", "CROWLEY COUNTY RE-1-J", "CUSTER COUNTY SCHOOL DISTRICT C-1",
      "DE BEQUE 49JT", "DEER TRAIL 26J", "DEL NORTE C-7", "DELTA COUNTY 50(J)", "DENVER COUNTY 1",
      "DOLORES COUNTY RE NO.2", "DOLORES RE-4A", "DOUGLAS COUNTY RE 1",
      "DURANGO 9-R", "EADS RE-1", "EAGLE COUNTY RE 50", "EAST GRAND 2",
      "EAST OTERO R-1", "EAST YUMA COUNTY RJ-2", "EATON RE-2", "EDISON 54 JT",
      "ELBERT 200", "ELIZABETH C-1", "ELLICOTT 22", "YUMA SCHOOL DISTRICT 1"]
    assert_equal names.sort, dr.districts.keys.sort
  end

  def test_can_find_district_by_name
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = dr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", result.name
    assert_equal District, result.class
  end

  def test_can_find_district_by_name_case_insensitive
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = dr.find_by_name("acaDEmy 20")
    assert_equal "ACADEMY 20", result.name
    assert_equal District, result.class
  end

  def test_find_by_all_returns_nil_for_no_search_results
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = dr.find_by_name("Turing School")
    assert_nil result
  end

  def test_can_return_all_matching_from_find_all_matching_search
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result_1 = []
    expected_1 = dr.find_all_matching("Tur")
    expected_2 = dr.find_all_matching("ADA")
    assert_equal result_1, expected_1
    assert_equal 2, expected_2.count
    assert expected_2.all? { |district| district.class == District }
  end

  def test_find_all_returns_matching_from_case_insensitive_search
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    expected = dr.find_all_matching("ada")
    assert_equal 2, expected.count
    assert expected.all? { |district| district.class == District }
  end

  def test_makes_enrollment_repository_when_loading_its_own_data
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    assert dr.er
    assert_equal EnrollmentRepository, dr.er.class
  end

  def test_district_repo_can_grab_enrollment_data
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    enrollment = dr.er.find_by_name("ACADEMY 20")
    assert_equal Enrollment, enrollment.class
    assert_equal "ACADEMY 20", enrollment.identifier[:name]
  end
end
