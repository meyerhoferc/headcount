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
    range, salary = clean_income_data(row)
      if @profiles.has_key?(name)
        profile = @profiles[name]
        range_salary = { range => salary }
        profile.identifier[:median_household_income] = range_salary
      else
        profile = EconomicProfile.new({ :name => name,
          :median_household_income => { range => salary },
          :children_in_poverty => {},
          :free_or_reduced_price_lunch => { },
          :title_i => { }})
        @profiles[name] = profile
      end
     end
  end

  def add_free_or_reduced_priced_lunch(file)
    file.each do |row|
      next if !desired_row(row)
       name = row[:location].upcase
       year, data = clean_lunch_data(row)
       profile = @profiles[name]
       if row[:dataformat].to_s.downcase == 'percent'
         if profile.identifier[:free_or_reduced_price_lunch].has_key?(year)
           profile.identifier[:free_or_reduced_price_lunch][year][:percentage] = data
         else
           percentage_data = { :percentage => data }
           profile.identifier[:free_or_reduced_price_lunch][year] = percentage_data
         end
       else
         if profile.identifier[:free_or_reduced_price_lunch].has_key?(year)
           profile.identifier[:free_or_reduced_price_lunch][year][:total] = data
         else
           total_students = { :total => data }
           profile.identifier[:free_or_reduced_price_lunch][year] = total_students
         end
       end
    end
  end

  def add_children_in_poverty(file)
    file.each do |row|
      next if row[:dataformat].to_s.downcase != 'percent'
       name = row[:location].upcase
       year, percentage = clean_poverty_data(row)
       profile = @profiles[name]
       profile.identifier[:children_in_poverty][year] = percentage
    end
  end

  def add_title_i(file)
    file.each do |row|
       name = row[:location].upcase
       year, percentage = clean_year(row[:timeframe]), clean_percent(row[:data])
       profile = @profiles[name]
       profile.identifier[:title_i][year] = percentage
    end
  end

  def clean_poverty_data(row)
    [clean_year(row[:timeframe]), clean_percent(row[:data])]
  end

  def clean_lunch_data(row)
    # return if !desired_row(row)
    return [clean_year(row[:timeframe]), clean_percent(row[:data])] if row[:dataformat].to_s.downcase == 'percent'
    [clean_year(row[:timeframe]), clean_salary(row[:data])] if row[:dataformat].to_s.downcase == 'number'
  end

  def desired_row(row)
    row_has_number = row[:dataformat].to_s.downcase == 'number'
    row_has_correct_number = row[:poverty_level].to_s.downcase == 'eligible for free or reduced lunch'
    row_has_percentage = row[:dataformat].to_s.downcase == 'percent'
    row_has_correct_percentage = row[:poverty_level].to_s.downcase == 'eligible for free or reduced lunch'
    (row_has_number && row_has_correct_number) || (row_has_percentage && row_has_correct_percentage)
  end

  def find_by_name(name)
    @profiles[name.upcase]
  end

  def create_and_add_profiles(data_tag, file)
  	add_median_household_data(file) if data_tag == :median_household_income
  	add_children_in_poverty(file) if data_tag == :children_in_poverty
  	add_free_or_reduced_priced_lunch(file) if data_tag == :free_or_reduced_price_lunch
  	add_title_i(file) if data_tag == :title_i
  end

  def clean_income_data(row)
    range = clean_range(row[:timeframe])
    salary = clean_salary(row[:data])
    [range, salary]
  end

  def clean_year(year)
    year = year.chars
    return year.join.ljust(4, "0") if year.count < 4
    if year[0] == "0"
      year.shift
      return year.join.ljust(4, "0").to_i
    end
    if year[-1] == "0"
      year.pop
      return year.join.ljust(4, "0").to_i
    end
    year.join.to_i
  end

  def clean_percent(data)
    return 0.0 if data.nil?
    return data if ["N/A", "LNE", "#VALUE!"].include?(data.upcase)
    return (data + '.').ljust(7, "0").to_f if data == "0" || data == "1"
    return data.ljust(7, "0").to_f if data.chars.count < 7
    data.to_s.to_f
  end

  def clean_range(range)
    digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    characters = range.to_s.chars
    new_range = characters.reject { |data| data if !digits.include?(data) }
    [new_range[0..3].join.to_i, new_range[4..7].join.to_i]
  end

  def clean_salary(salary)
    salary.to_i
  end
end
