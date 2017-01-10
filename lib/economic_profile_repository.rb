require_relative 'data_load'
require_relative 'economic_profile'
require 'pry'

class EconomicProfileRepository
  include DataLoad
  attr_reader :profiles
  def initialize
    @profiles = Hash.new
  end

  def load_data(data)
    contents = load_files(data, :economic_profile)
    economic_profile_maker(contents)
  end

  def economic_profile_maker(contents)
  	contents.each_pair do |data_tag, file|
  		create_and_add_profiles(data_tag, file)
  	end
  end

  def add_median_household_data(file)
   file.each do |row|
    name = row[:location].upcase
    range, integer = clean_income_data(row)
      if @profiles.has_key?(name)
      	add_data([data_tag, year, tag, data, name])
      else
        profiles = EconomicProfile.new({ :name => name,
          :median_household_income => { range => integer }
          :children_in_poverty => { }, 
          :free_or_reduced_priced_lunch => { }, 
          :title_i => { }, })
        @profile[name] = profile
     end
  end

  def find_by_name(name)
    @profiles[name.upcase]
  end

  def create_and_add_profiles(data_tag, file)
  	add_median_household_data(file) if data_tag == :median_household_income
  	add_children_in_poverty(file) if data_tag == :children_in_poverty
  	add_free_or_reduced_priced_lunch if data_tag == :free_or_reduced_priced_lunch
  	add_title_i if data_tag == :title_i
  end
end 
