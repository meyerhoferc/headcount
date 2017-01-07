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
    assert_equal Array, load_files(data).class
    assert_equal 2, load_files(data).count
  end

  def test_can_returns_column_of_data
    locations = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14', 'BIG SANDY 100J',
    'BRIGGSDALE RE-10', 'DE BEQUE 49JT',
    'WELD COUNTY RE-1', 'WELD COUNTY S/D RE-8']
    kindergarten, high_school_graduation = load_files(data)
    assert_equal Array, get_column(kindergarten, location).class
    assert_equal locations, get_column(kindergarten, location)
    assert_equal Array, get_column(high_school_graduation, location).class
    assert_equal locations, get_column(high_school_graduation, location)
  end

  def test_can_return_row_of_data
    skip
    file = './test/fixtures/high_school_graduation_rates_sample.csv'
    data = [Colorado,2010,Percent,0.724]
    contents = load_files(file)
    assert_equal Array, contents.get_row(0).class
    assert_equal data, contents.get_row(0)
  end

end
