require_relative 'test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repo'

class StatewideTestRepoTest < Minitest::Test
  attr_reader :str
  def setup
    @str = StatewideTestRepo.new
  end

  def test_it_is_a_statewide_test_repo
    skip
  end

  def test_has_collection_of_statewide_test_objects
    skip
    # @swtests hash key = name, value = swt object
  end

  def test_can_get_data_from_swt_object
    skip
    # look at keys and grabbing data in identifier for academy 20
  end

  def test_can_load_data
    skip
    # can it grab correct files
    # use data load module
    # look at enrollment repo tests
    # look at LNE and N/A and 0 conditionals
  end

  def test_can_find_swt_by_name
    skip
    # find_by_name(name) => swt object or nil
  end

  # check out enrollment repo for more test inspiration
end
