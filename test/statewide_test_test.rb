require_relative 'test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repo'

class StatewideTestTest < Minitest::Test
  attr_reader :st
  def setup
    @st = StatewideTest.new
  end

end
