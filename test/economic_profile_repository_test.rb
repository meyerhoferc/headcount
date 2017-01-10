require_relative 'test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repository'
require './lib/data_load'

class EconomicProfileRepositoryTest < Minitest::Test
  include DataLoad
  attr_reader :epr
  def setup
    @epr = EconomicProfileRepository.new
  end

end
