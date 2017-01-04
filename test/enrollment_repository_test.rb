require_relative 'test_helper'
require './lib/enrollment'
require './lib/enrollment_repository'


class EnrollmentRepositoryTest < Minitest::Test
  attr_reader :er
  def setup
    @er = EnrollmentRepository.new
  end

  def test_it_is_an_enrollment_repository
    assert er
    assert_equal EnrollmentRepository, er.class
  end

  def test_

  end
end
