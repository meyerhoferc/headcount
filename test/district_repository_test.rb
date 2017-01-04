require_relative 'test_helper'
require './lib/district'
require './lib/district_repository'
require 'csv'
# require 'Kindergarten_sample_data.csv'

class DistrictRepositoryTest < Minitest::Test
  attr_reader :dr, :sample_data
  def setup
    @dr = DistrictRepository.new
  end

  def load
    @sample_data = CSV.open("kindergarten_sample_data.csv")
  end

  def test_it_a_district_repo
    assert dr
    assert_equal DistrictRepository, dr.class
  end

  def test_empty_districts_by_default
    assert dr.districts
    assert_equal Hash, dr.districts.class
    assert dr.districts.empty?
  end

  def test_sample_data_names_are_in_districts_keys
    dr.load_data({:enrollment => {:kindergarten => './test/Kindergarten_sample_data.csv'}})
    assert_equal 6, dr.districts.count
    names = ["ACADEMY 20", "ADAMS COUNTY 14", "ADAMS-ARAPAHOE 28J", "AGATE 300", "BENNETT 29J", "YUMA SCHOOL DISTRICT 1"]
    assert_equal names.sort, dr.districts.keys.sort
  end

end
