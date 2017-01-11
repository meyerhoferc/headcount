require_relative 'test_helper'
require './lib/insufficient_information_error'

class InsufficientInformationErrorTest < Minitest::Test
  def testing_error(value)
    if value
      value
    else
      raise InsufficientInformationError
    end
  end

  def test_it_raises_unknown_race_error
    assert_raises(InsufficientInformationError) { testing_error(nil) }
  end
end
