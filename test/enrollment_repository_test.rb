require_relative 'test_helper'
require './lib/enrollment'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test
  attr_reader :er,
              :er_2
  def setup
    @er = EnrollmentRepository.new
    @er_2 = EnrollmentRepository.new
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
    er.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv',
      :high_school_graduation => './test/fixtures/high_school_graduation_rates_sample.csv'}})

    assert_equal 9, er.enrollments.count
    names = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J",
      "BIG SANDY 100J", "BRIGGSDALE RE-10", "DE BEQUE 49JT",
      "WELD COUNTY RE-1", "WELD COUNTY S/D RE-8"]
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
    enrollment = er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", enrollment.name
    assert_equal Enrollment, enrollment.class
    assert_equal 0.392, enrollment.kindergarten_participation_in_year(2007)
    assert_equal 0.267, enrollment.kindergarten_participation_in_year(2005)
  end


  def test_adds_high_school_grad_data_in_load
    er_2.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv',
      :high_school_graduation => './test/fixtures/high_school_graduation_rates_sample.csv'}})
    enrollment = er_2.find_by_name("acaDEmy 20")

    assert_equal "ACADEMY 20", enrollment.name
    assert_equal Enrollment, enrollment.class

    assert_equal 0.392, enrollment.kindergarten_participation_in_year(2007)
    assert_equal 0.267, enrollment.kindergarten_participation_in_year(2005)
    assert_equal 0.895, enrollment.graduation_rate_in_year(2010)
    assert_equal 0.898, enrollment.graduation_rate_in_year(2014)

    expected = { 2010 => 0.895, 2011 => 0.895, 2012 => 0.889,
      2013 => 0.913, 2014 => 0.898 }
    actual = enrollment.graduation_rate_by_year
    
    expected.each_pair do |year, data|
      assert_in_delta data, actual[year], 0.005
    end
  end
end
