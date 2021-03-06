require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require_relative 'data_cleaner'
require 'csv'
class DistrictRepository
  include DataLoad
  include DataCleaner
  attr_reader :districts,
              :er,
              :str,
              :epr
  def initialize
    @districts = Hash.new
  end

  def load_data(data)
    er_data = choose_file(data, :enrollment)
    str_data = choose_file(data, :statewide_testing)
    epr_data = choose_file(data, :economic_profile)
    @er = EnrollmentRepository.new
    @er.load_data(er_data)
    unless str_data[:statewide_testing].nil?
      @str = StatewideTestRepository.new
      @str.load_data(str_data)
    end
    unless epr_data[:economic_profile].nil?
      @epr = EconomicProfileRepository.new
      @epr.load_data(epr_data)
    end
    contents = load_files(data)
    kindergarten = contents[:kindergarten]
    district_maker(kindergarten)
  end

  def choose_file(data, desired_key)
    selected_data = data.reject do |key, file|
      key != desired_key
    end
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
    matching_districts = @districts.reject do |name, district|
      district if !district.name.start_with?(sub_name.upcase)
    end
    matching_districts.values
  end
end
