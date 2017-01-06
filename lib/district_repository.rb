require_relative 'district'
require_relative 'enrollment_repository'
require 'csv'
require 'pry'
class DistrictRepository
  attr_reader :districts,
              :er
  def initialize
    @districts = Hash.new
  end

  def load_data(data)
    @er = EnrollmentRepository.new
    @er.load_data(data)
    file_name = data[:enrollment][:kindergarten]
    contents = CSV.open file_name,
    headers: true, header_converters: :symbol

    district_maker(contents)
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
    @districts.each_pair do |key, value|
      matching_districts[key] = value if key.include?(sub_name.upcase)
    end
    matching_districts.values
  end
end
