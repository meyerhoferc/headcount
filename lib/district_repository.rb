require './lib/district'
require 'csv'
require 'pry'
class DistrictRepository
  attr_reader :districts
  def initialize
    @districts = Hash.new
  end

  def load_data(data)
    file_name = data[:enrollment][:kindergarten]
    contents = CSV.open file_name,
    headers: true, header_converters: :symbol
    district_maker(contents)
  end

  def district_maker(contents)
    contents.each do |row|
      name = row[:location].upcase
      district = District.new
      @districts[name] = district unless @districts.has_key?(name)
      district.identifier[:name] = name
    end
  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(sub_name)
    @districts.each_key do |key|
      binding.pry
      key.include?(sub_name)
    end
  end
end
