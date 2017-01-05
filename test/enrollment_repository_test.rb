require_relative 'test_helper'
require './lib/enrollment'
require './lib/enrollment_repository'


class EnrollmentRepositoryTest < Minitest::Test
  attr_reader :er
  def setup
    @er = EnrollmentRepository.new
  end

  def test_it_is_an_enrollment_repository
    assert er
    assert_equal EnrollmentRepository, er.class
  end

  def test_empty_enrollments_by_default
    assert er.enrollments
    assert_equal Hash, er.enrollments.class
    assert er.enrollments.empty?
  end

  def test_clean_occupancy_returns_correct_possible_data
    given_1, given_2, given_3, given_4, given_5 = ["0", "1", "0.12345", "N/A", "0.123"]
    result = ["0.00000", "1.00000", "0.12345", "N/A", "0.12300"]
    expected_1, expected_2, expected_3, expected_4, expected_5 = result
    assert_equal expected_1, er.clean_occupancy(given_1)
    assert_equal expected_2, er.clean_occupancy(given_2)
    assert_equal expected_3, er.clean_occupancy(given_3)
    assert_equal expected_4, er.clean_occupancy(given_4)
    assert_equal expected_5, er.clean_occupancy(given_5)
  end

  def test_clean_year_returns_sample_data_correctly
    sample_1, sample_2, sample_3, sample_4, sample_5 = ["200", "2007", "02010", "20120", "2017"]
    result = ["2000", "2007", "2010", "2012", "2017"]
    expected_1, expected_2, expected_3, expected_4, expected_5 = result
    assert_equal expected_1, er.clean_year(sample_1)
    assert_equal expected_2, er.clean_year(sample_2)
    assert_equal expected_3, er.clean_year(sample_3)
    assert_equal expected_4, er.clean_year(sample_4)
    assert_equal expected_5, er.clean_year(sample_5)
  end

  def test_sample_data_names_are_in_enrollments_keys
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    assert_equal 27, er.enrollments.count
    names = ["ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J", "AGATE 300",
      "BENNETT 29J", "CROWLEY COUNTY RE-1-J", "CUSTER COUNTY SCHOOL DISTRICT C-1",
      "DE BEQUE 49JT", "DEER TRAIL 26J", "DEL NORTE C-7", "DELTA COUNTY 50(J)", "DENVER COUNTY 1",
      "DOLORES COUNTY RE NO.2", "DOLORES RE-4A", "DOUGLAS COUNTY RE 1",
      "DURANGO 9-R", "EADS RE-1", "EAGLE COUNTY RE 50", "EAST GRAND 2",
      "EAST OTERO R-1", "EAST YUMA COUNTY RJ-2", "EATON RE-2", "EDISON 54 JT",
      "ELBERT 200", "ELIZABETH C-1", "ELLICOTT 22", "YUMA SCHOOL DISTRICT 1"]
    assert_equal names.sort, er.enrollments.keys.sort
  end

  def test_can_find_enrollment_by_name
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", result.identifier[:name]
    assert_equal Enrollment, result.class
  end

  def test_can_find_enrollment_by_name_case_insensitive
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = er.find_by_name("acaDEmy 20")
    assert_equal "ACADEMY 20", result.identifier[:name]
    assert_equal Enrollment, result.class
  end

  def test_find_by_all_returns_nil_for_no_search_results
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = er.find_by_name("Turing School")
    assert_nil result
  end

  def test_can_find_enrollment_for_district_in_year
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    enrollment = er.find_by_name("ADAMS-ARAPAHOE 28J")
    assert_equal "ADAMS-ARAPAHOE 28J", enrollment.name
    assert_equal Enrollment, enrollment.class
    assert_equal 0.47359, enrollment.kindergarten_participation_in_year(2007)
    assert_equal 0.20176, enrollment.kindergarten_participation_in_year(2005)
  end
end
