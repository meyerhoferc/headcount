require_relative 'test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repo'

class StatewideTestRepoTest < Minitest::Test
  attr_reader :str
  def setup
    @str = StatewideTestRepo.new
  end

end
