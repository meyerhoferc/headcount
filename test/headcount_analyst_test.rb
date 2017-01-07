require_relative 'test_helper'
require './lib/enrollment'
require './lib/district'
require './lib/enrollment_repository'
require './lib/district_repository'
require './lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr,
              :ha
  def setup
    @dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
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
    district_name = 'ADAMS-ARAPAHOE 28J'
    actual = ha.find_average(district_name)
    expected = (0.47359 + 0.20176) / 2
    assert_equal expected.round(5), actual
    assert_equal 0.53039, ha.find_average('COLORADO')
  end

  def test_can_compare_two_averages
    district_name = 'ADAMS-ARAPAHOE 28J'
    district_name_2 = 'DENVER COUNTY 1'
    district_1_average = ha.find_average(district_name)
    district_2_average = ha.find_average(district_name_2)
    expected = district_1_average / district_2_average
    actual = ha.compare_averages(district_name, district_name_2)
    assert_equal expected.round(3), actual
  end

  def test_kindergarten_participation_rate_variation_against_state_performance
    district_1_name = 'ADAMS-ARAPAHOE 28J'
    district_2_name = 'ACADEMY 20'
    actual_1 = ha.kindergarten_participation_rate_variation(district_1_name, :against => 'COLORADO')
    actual_2 = ha.kindergarten_participation_rate_variation(district_2_name, :against => 'COLORADO')
    assert_equal 0.766, actual_2
    expected = ha.compare_averages(district_1_name, 'COLORADO')
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
    assert_raises(NameError) { ha.find_enrollment("MADEUP NAME") }
    assert_raises(NameError) { ha.kindergarten_participation_rate_variation('UNKNOWN 20', against: 'ARIZONA') }
  end

end
