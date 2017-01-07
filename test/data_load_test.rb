require_relative 'test_helper'
require './lib/data_load.rb'
require 'pry'

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
  end

  def test_can_return_location_for_row
    skip
    rows = [["BRIGGSDALE RE-10",2010,Percent,1], ["BIG SANDY 100J",2010,Percent,1],
  ["ACADEMY 20",2013,Percent,0.91373], ["ADAMS COUNTY 14",2011,Percent,0.608]]

  end

  def test_can_return_time_for_row
    skip
  end

  def test_can_return_data_for_row
    skip
  end

end
