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
    skip
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", result.name
    assert_equal Enrollment, result.class
  end

  def test_can_find_enrollment_by_name_case_insensitive
    skip
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = er.find_by_name("acaDEmy 20")
    assert_equal "ACADEMY 20", result.name
    assert_equal Enrollment, result.class
  end

  def test_find_by_all_returns_nil_for_no_search_results
    skip
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    result = er.find_by_name("Turing School")
    assert_nil result
  end
end
