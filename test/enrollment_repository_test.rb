require_relative 'test_helper'
require './lib/enrollment'
require './lib/enrollment_repository'


class EnrollmentRepositoryTest < Minitest::Test
  attr_reader :er
  def setup
    @er = EnrollmentRepository.new
  end
end
