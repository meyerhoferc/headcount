require_relative 'test_helper'
require './lib/unknown_race_error'

class UnknownRaceErrorTest < Minitest::Test
  def testing_error(value)
    if value
      value
    else
      raise UnknownRaceError
    end
  end

  def test_it_raises_unknown_race_error
    assert_raises(UnknownRaceError) { testing_error(nil) }
  end
end
