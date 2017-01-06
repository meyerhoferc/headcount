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
    assert_equal 0.39159, district.enrollment.kindergarten_participation_in_year(2007)
  end
end
