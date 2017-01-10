require_relative 'test_helper'
require './lib/district'
require './lib/district_repository'
require 'csv'

class DistrictRepositoryTest < Minitest::Test
  attr_reader :dr, :sample_data
  def setup
    @dr = DistrictRepository.new
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
    assert_equal 9, dr.districts.count
    names = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J",
      "BIG SANDY 100J", "BRIGGSDALE RE-10", "DE BEQUE 49JT",
      "WELD COUNTY RE-1", "WELD COUNTY S/D RE-8"]
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
    assert_equal [], dr.find_all_matching("Tur")
    expected_2 = dr.find_all_matching("A")
    assert_equal 3, expected_2.count
    assert expected_2.all? { |district| district.class == District }
  end

  def test_find_all_returns_matching_from_case_insensitive_search
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    expected = dr.find_all_matching("a")
    assert_equal 3, expected.count
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

  def test_passes_self_to_districts_in_district_maker
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    district = dr.find_by_name("ACADEMY 20")
    assert_equal DistrictRepository, district.repo.class
  end

  def test_makes_swt_repo_when_loading_its_own_data
    dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv",
  },
  :statewide_testing => {
    :third_grade => "./test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
    :eighth_grade => "./test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
    :math => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
    :reading => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
    :writing => "./test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  }})
    #
    # district = dr.find_by_name('ACADEMY 20')
    # statewide_test = dr.statewide_test_repo.find_by_name('ACADEMY 20')
    # assert_equal 'ACADEMY 20', statewide_test.name
    # assert_equal StatewideTest, statewide_test.class
  end
end
