require_relative 'test_helper'
require './lib/unknown_data_error'

class UnknownRaceErrorTest < Minitest::Test
  def testing_error(value)
    if value
      value
    else
      raise UnknownDataError
    end
  end

  def test_it_raises_unknown_race_error
    assert_raises(UnknownDataError) { testing_error(nil) }
  end
end
