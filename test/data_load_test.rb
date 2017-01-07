require_relative 'test_helper'
require './lib/data_load.rb'
require 'pry'

class DataLoadTest < Minitest::Test
  include DataLoad

  def test_it_can_open_csv
    skip
    assert load_files('./test/fixtures/high_school_graduation_rates_sample.csv')
  end

  def test_it_opening_returns_array_of_files
    skip
    assert_equal Array, load_files(files).class
    assert_equal 3, load_files(files).count
  end

  def test_can_returns_column_of_data
    skip
    names = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14', 'BIG SANDY 100J',
    'BRIGGSDALE RE-10', 'DE BEQUE 49JT',
    'WELD COUNTY RE-1', 'WELD COUNTY S/D RE-8']
    file = './test/fixtures/high_school_graduation_rates_sample.csv'
    contents = load_files(file)
    assert_equal Array, contents.get_column(location).class
    assert_equal names, contents.get_column(location)
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
