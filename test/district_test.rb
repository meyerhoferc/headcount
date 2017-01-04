require_relative 'test_helper'
require './lib/district'

class DistrictTest < Minitest::Test
  attr_reader :district
  def setup
    @district = District.new
  end
end
