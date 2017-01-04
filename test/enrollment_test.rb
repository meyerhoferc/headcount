require_relative 'test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :enrollment
  def setup
    @enrollment = Enrollment.new
  end
end
