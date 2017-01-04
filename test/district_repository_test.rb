require_relative 'test_helper'
require './lib/district'
require './lib/district_repository'


class DistrictRepositoryTest < Minitest::Test
  attr_reader :dr
  def setup
    @dr = DistrictRepository.new
  end
end
