require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require 'csv'
require 'pry'
class DistrictRepository
  include DataLoad
  attr_reader :districts,
              :er
  def initialize
    @districts = Hash.new
  end

  def load_data(data)
    @er = EnrollmentRepository.new
    @er.load_data(data)
    # @str = StatewideTestRepository.new
    # @str.load_data(data)
    contents = load_files(data)
    kindergarten = contents[:kindergarten]
    district_maker(kindergarten)
  end

  def district_maker(contents)
    contents.each do |row|
      name = row[:location].upcase
      district = District.new({:name => name, :repo => self})
      @districts[name] = district unless @districts.has_key?(name)
    end
  end

  def find_by_name(name)
    @districts[name.upcase]
  end

  def find_all_matching(sub_name)
    matching_districts = {}
    @districts.each do |name, district|
      matching_districts[district.name] = district if district.name.start_with?(sub_name.upcase)
    end
    matching_districts.values
  end
end
