require_relative 'test_helper'
require './lib/district'

class DistrictTest < Minitest::Test
  attr_reader :district
  def setup
    @district = District.new({:name => "ACADEMY 20"})
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
end
