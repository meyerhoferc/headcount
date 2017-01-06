require_relative 'test_helper'
require './lib/enrollment'
require './lib/district'
require './lib/enrollment_repository'
require './lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr,
              :ha
  def setup
    @dr = DistrictRepository.new
    @ha = HeadcountAnalyst.new(dr)
    dr.load_data({:enrollment => {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv'}})
  end

  def test_it_is_a_headcount_analyst
    skip
    assert ha
    assert_equal HeadcountAnalyst, ha.class
  end

  def test_it_has_district_repository_by_default
    skip
    assert_equal DistrictRepository, ha.repositories.first
  end

  def test_can_find_average_enrollment_for_district
    skip
    district_name = 'ADAMS-ARAPAHOE 28J'
    actual = ha.find_average(district_name)
    expected = 0.47359 #this is actual figure
    assert_equal expected, actual
  end

  def test_kindergarten_participation_rate_variation_against_state_performance
    skip
    district_name = 'ADAMS-ARAPAHOE 28J'
    # expected = 0.47359
    assert_equal 0.47359, ha.kindergarten_participation_rate_variation('ADAMS-ARAPAHOE', against: 'COLORADO')
    assert_equal 1.0, @ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'ACADEMY 20') #baseline figure
    assert_equal , ha.kindergarten_participation_rate_variation()
    assert_equal "#{insert rate variation value}", @ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'ADAMS-ARAPAHOE')
    refute "#{error}" { @ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'ARIZONA') }
    #potentially do another assertion for error values thrown? differing data?
  end 
end
