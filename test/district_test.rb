require_relative 'test_helper'
require './lib/district'
require './lib/district_repository'

class DistrictTest < Minitest::Test
  attr_reader :district,
              :dr
  def setup
    @dr = DistrictRepository.new
    @district = District.new({:name => "ACADEMY 20", :repo => @dr})
  end

  def test_it_is_district_class
    assert district
    assert_equal District, district.class
  end

  def test_it_has_identifier
    assert district.identifier
  end

  def test_it_has_a_name
    district.identifier[:name] = "ACADEMY 20"
    assert district.name
    assert_equal "ACADEMY 20", district.name
  end

  def test_name_is_an_upcase_string
    district.identifier[:name] = "ACADEMY 20"
    name_1 = "ACADEMY 20"
    name_2 = "academy 20"
    assert_equal name_1, district.name
    refute_equal name_2, district.name
  end

  def test_distrist_knows_it_is_in_repository
    assert_equal DistrictRepository, district.repo.class
  end

  def test_district_can_find_enrollment_with_same_name
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    enrollment = district.enrollment
    assert_equal Enrollment, enrollment.class
    assert_equal district.name, enrollment.identifier[:name]
  end

  def test_district_can_get_enrollment_occupancy_for_year
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
    enrollment = district.enrollment
    assert_equal 0.392, district.enrollment.kindergarten_participation_in_year(2007)
  end

  def test_district_can_find_statewide_test_with_same_name
    dr.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv",
    :high_school_graduation => "./data/High school graduation rates.csv",
  },
  :statewide_testing => {
    :third_grade => "./test/fixtures/3rd_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :eighth_grade => "./test/fixtures/8th_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :math => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Math.csv",
    :reading => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Reading.csv",
    :writing => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Writing.csv"
  }})

    statewide_test = district.statewide_test
    assert_equal district.name, statewide_test.name
    assert_equal StatewideTest, statewide_test.class
    assert_equal 0.857, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_district_can_find_economic_profile_with_same_name
    dr.load_data({
  :enrollment => {
    :kindergarten => "./test/fixtures/Kindergarten_sample_data.csv",
    :high_school_graduation => "./test/fixtures/high_school_graduation_rates_sample.csv",
  },
  :statewide_testing => {
    :third_grade => "./test/fixtures/3rd_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :eighth_grade => "./test/fixtures/8th_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :math => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Math.csv",
    :reading => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Reading.csv",
    :writing => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Writing.csv"
  },
  :economic_profile => {
    :median_household_income => "./test/fixtures/Median_household_income.csv",
    :children_in_poverty => "./test/fixtures/School_aged_children_in_poverty.csv",
    :free_or_reduced_price_lunch => "./test/fixtures/Students_qualifying_for_free_or_reduced_price_lunch.csv",
    :title_i => "./test/fixtures/Title_I_students.csv"
  }})

    ep = district.economic_profile
    assert_equal district.name, ep.name
    assert_equal EconomicProfile, ep.class
  end
end
