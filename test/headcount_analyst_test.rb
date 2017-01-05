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
    district_name = 'ACADEMY 20' # ADAMS-ARAPAHOE here
    actual = ha.find_average(district_name)
    expected = 0.234322432 #not actually
    assert_equal expected, actual
  end
end
