require_relative 'test_helper'
require './lib/data_load.rb'

class DataLoadTest < Minitest::Test
  include DataLoad
  attr_reader :data
  def setup
    @data = {:enrollment =>
      {:kindergarten => './test/fixtures/Kindergarten_sample_data.csv',
      :high_school_graduation =>
      './test/fixtures/high_school_graduation_rates_sample.csv'}}
  end

  def test_it_can_open_csv
    assert load_files(data)
  end

  def test_it_opening_returns_array_of_files
    assert_equal Hash, load_files(data).class
    assert_equal 2, load_files(data).count
    assert_equal [:kindergarten, :high_school_graduation], load_files(data).keys
    assert load_files(data).values.all? { |object| object.class == CSV }
  end
end
