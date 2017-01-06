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
    assert_equal expected, actual
  end

  def test_can_compare_two_averages
    district_name = 'ADAMS-ARAPAHOE 28J'
    district_name_2 = 'DENVER COUNTY 1' #0.72181
    district_1_average = ha.find_average(district_name)
    district_2_average = ha.find_average(district_name_2)
    expected = district_1_average / district_2_average #work out this value
    actual = ha.compare_averages(district_name, district_name_2)
    assert_equal expected, actual
  end

  def test_kindergarten_participation_rate_variation_against_state_performance
    skip
    district_1_name = 'ADAMS-ARAPAHOE 28J'
    district_2_name = 'ACADEMY 20'
    # district_1_average = ha.find_average(district_1_name)
    # district_2_average = ha.find_average(district_2_name)
    actual_1 = ha.kindergarten_participation_rate_variation(district_1_name, :against 'COLORADO')
    actual_2 = ha.kindergarten_participation_rate_variation(district_1_name, :against 'COLORADO')
    # assert_equal NUM, actual_1
    assert_equal 0.766, actual_2
    # assert_equal 0.766, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against 'COLORADO')
    # assert_equal , ha.kindergarten_participation_rate_variation('ADAMS-ARAPAHOE 28J', :against 'COLORADO')
    assert_equal 1.0, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against 'ACADEMY 20') #baseline figure
    # assert_equal "#{insert rate variation value}", ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'ADAMS-ARAPAHOE')
    # assert_raise "#{unknown data}", ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'ARIZONA') }
    #potentially do another assertion for error values thrown? differing data?
  end 
  def test_kindergarten_participation_rate_variation_trend_year_on_year
    # district_name = 'ADAMS-ARAPAHOE 28J'
    # #returns hash: rate variation trend
  end
  
end
