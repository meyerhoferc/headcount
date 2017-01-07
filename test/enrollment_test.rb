require_relative 'test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :enrollment
  def setup
    @enrollment = Enrollment.new({:name => "ACADEMY 20",
      :kindergarten_participation => { 2001 => 0.312, 2003 => 0.452 },
      :high_school_graduation => { 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898 }})
  end

  def test_it_is_an_enrollment_class
    assert enrollment
    assert_equal Enrollment, enrollment.class
  end

  def test_it_has_identifier
    assert enrollment.identifier
  end

  def test_it_has_a_name
    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_it_stores_the_name_of_a_district
    assert_equal "ACADEMY 20", enrollment.identifier[:name]
  end

  def test_can_return_kindergarten_participation_by_year
    expected = { 2001 => 0.312, 2003 => 0.452}
    result = enrollment.kindergarten_participation_by_year
    assert_equal expected, result
  end

  def test_can_return_kindergarten_participation_for_a_year
    expected_1 = 0.312
    expected_2 = 0.452
    result_1 = enrollment.kindergarten_participation_in_year(2001)
    result_2 = enrollment.kindergarten_participation_in_year(2003)

    assert_equal expected_1, result_1
    assert_equal expected_2, result_2
    assert_equal Float, result_1.class
    assert_equal Float, result_2.class
  end

  def test_grad_rate_by_year
    result = { 2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898 }
    assert_equal result, enrollment.graduation_rate_by_year
  end

  def test_grad_rate_in_year
    result_1, result_2, result_3 = [0.895, 0.889, 0.898]
    assert_equal result_1, enrollment.graduation_rate_in_year(2010)
    assert_equal result_2, enrollment.graduation_rate_in_year(2012)
    assert_equal result_3, enrollment.graduation_rate_in_year(2014)
    assert_equal Float, result_3.class
    assert_equal Float, result_1.class
    assert_equal Float, result_2.class
  end


end
