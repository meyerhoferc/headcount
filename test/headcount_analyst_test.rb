require_relative 'test_helper'
require './lib/enrollment'
require './lib/district'
require './lib/enrollment_repository'
require './lib/district_repository'
require './lib/headcount_analyst'
require './lib/statewide_test'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr,
              :ha
  def setup
    @dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv',
      :high_school_graduation => './test/fixtures/high_school_graduation_rates_sample.csv'}})
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_it_is_a_headcount_analyst
    assert ha
    assert_equal HeadcountAnalyst, ha.class
  end

  def test_it_has_district_repository_by_default
    assert_equal DistrictRepository, ha.dr.class
  end

  def test_can_find_average_enrollment_for_district
    district_name = 'ACADEMY 20'
    actual = ha.find_average(district_name, :kindergarten)
    data = [0.39159, 0.35364, 0.26709, 0.30201, 0.38456, 0.3900,
      0.43628, 0.48900, 0.47883, 0.48774, 0.49022]
    expected = (data.reduce(:+) / data.count)
    assert_in_delta expected.round(5), actual, 0.005
    assert_in_delta 0.53039, ha.find_average('COLORADO', :kindergarten), 0.005
  end

  def test_can_compare_two_averages
    district_name = 'ACADEMY 20'
    district_name_2 = 'ADAMS COUNTY 14'
    district_1_average = ha.find_average(district_name, :kindergarten)
    district_2_average = ha.find_average(district_name_2, :kindergarten)
    expected = district_1_average / district_2_average
    actual = ha.compare_averages(district_name, district_name_2, :kindergarten)
    assert_equal expected.round(3), actual
  end

  def test_kindergarten_participation_rate_variation_against_state_performance
    district_1_name = 'ADAMS-ARAPAHOE 28J'
    district_2_name = 'ACADEMY 20'
    actual_1 = ha.kindergarten_participation_rate_variation(district_1_name, :against => 'COLORADO')
    actual_2 = ha.kindergarten_participation_rate_variation(district_2_name, :against => 'COLORADO')
    assert_equal 0.766, actual_2
    expected = ha.compare_averages(district_1_name, 'COLORADO', :kindergarten)
    assert_equal expected, ha.kindergarten_participation_rate_variation('ADAMS-ARAPAHOE 28J', :against => 'COLORADO')
    assert_equal 1.0, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ACADEMY 20')
  end

  def test_kindergarten_participation_rate_variation_trend_year_on_year
    expected = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992,
      2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 =>
      0.688, 2013 => 0.694, 2014 => 0.661 }
    actual = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    actual.each_pair do |year, value|
      assert_in_delta expected[year], value, 0.005
    end
  end

  def test_returns_unknown_data_error
    assert_raises(UnknownDataError) { ha.find_enrollment("MADEUP NAME") }
    assert_raises(UnknownDataError) { ha.kindergarten_participation_rate_variation('UNKNOWN 20', against: 'ARIZONA') }
  end

  def test_adds_high_school_grad_variation_against_state_performance
    district_name_1 = "ACADEMY 20"
    state = 'COLORADO'
    actual_1 = ha.high_school_graduation_rate_variation(district_name_1, :against => "COLORADO")
    assert_in_delta 1.195, actual_1, 0.005
  end

  def test_compares_kindergarten_and_high_school_data
    high_school = ha.high_school_graduation_rate_variation('ACADEMY 20', :against => "COLORADO")
    kindergarten = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    variation = kindergarten / high_school
    actual = ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_in_delta variation, actual, 0.005
  end

  def test_checks_for_correlation_between_kindergarten_and_high_school
    dr_2 = DistrictRepository.new
    dr_2.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"}})
    ha_2 = HeadcountAnalyst.new(dr_2)
    assert ha_2.kindergarten_participation_correlates_with_high_school_graduation(:for => 'ACADEMY 20')
    refute ha_2.kindergarten_participation_correlates_with_high_school_graduation(:for => 'MONTROSE COUNTY RE-1J')
    refute ha_2.kindergarten_participation_correlates_with_high_school_graduation(:for => 'SIERRA GRANDE R-30')
    assert ha_2.kindergarten_participation_correlates_with_high_school_graduation(:for => 'PARK (ESTES PARK) R-3')
    refute ha_2.check_statewide
    refute ha_2.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
    districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
    assert ha_2.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  end

  def test_can_calculate_year_over_year_growth_for_statewide_tests
    data = [[2008, 0.857], [2009, 0.752], [2010, 0.567], [2011, 0.993]]
    actual = ha.year_over_year_growth(data)
    expected = 0.045
    assert_equal expected, actual
  end

  def test_can_calculate_year_over_year_growth_for_mixed_data
    data = [[2008, "N/A"], [2009, 0.752], [2010, "LNE"], [2011, 0.993]]
    actual = 0.121
    assert_equal actual, ha.year_over_year_growth(data)
  end

  def test_can_return_nested_array_of_year_and_data_for_statewide_test
    dr_3 = DistrictRepository.new
    dr_3.load_data({
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
    statewide_test = dr_3.str.find_by_name('ACADEMY 20')
    data = ha.year_and_percentage({:subject => :math, :grade => 3}, statewide_test)
    assert_equal Array, data.class
    assert_equal Fixnum, data[0][0].class
    assert_equal Float, data[0][1].class
  end

  def test_raises_errors_if_not_given_enough_or_correct_information
    dr_4 = DistrictRepository.new
    dr_4.load_data({
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
    ha_3 = HeadcountAnalyst.new(dr_4)
    assert_raises(InsufficientInformationError) { ha_3.top_statewide_test_year_over_year_growth(subject: :math) }
    assert_raises(UnknownDataError) { ha_3.top_statewide_test_year_over_year_growth(grade: 9, subject: :math) }
    actual = ha_3.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal Array, actual.class
    assert_equal String, actual[0].class
    assert_equal Float, actual[1].class
  end

  def test_can_find_top_set_of_performers
    dr_4 = DistrictRepository.new
    dr_4.load_data({
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
    ha_3 = HeadcountAnalyst.new(dr_4)
    actual = ha_3.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    assert_equal 3, actual.count
    assert_equal String, actual[0][0].class
    assert_equal Float, actual[0][1].class
  end
end
