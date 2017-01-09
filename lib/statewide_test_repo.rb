require_relative 'data_load'
require 'pry'

class StatewideTestRepo
  include DataLoad
  attr_reader :swtests
  def initialize
    @swtests = Hash.new
  end

  def load_data(data)
    contents = load_files(data, :statewide_testing)
    statewide_test_maker(contents)
  end

  def statewide_test_maker(contents) #takes in hash of data tags & opened files
    contents.each_pair do |data_tag, file|
      add_data(data_tag, file)
    end
  end

  def add_data(data_tag, file)
    file.each do |row|
      name = row[:location].upcase
      year, tag, data = clean_data(row)
      if @swtests.has_key?(name)
        swtest = @swtests[name]
        if [:third_grade, :eighth_grade].include?(data_tag)
          if swtest.identifier[data_tag].has_key?(year)
            swtest.identifier[data_tag][year][tag] = data
          else
            grades_data = { tag => data }
            swtest.identifier[data_tag][year] = grades_data
          end
        else
          if swtest.identifier[tag].has_key?(year)
            swtest.identifier[tag][year][data_tag] = data
          else
            ethnicity_data = { data_tag => data }
            swtest.identifier[tag][year] = ethnicity_data
          end
        end
      else
        swtest = StatewideTest.new({ :name => name,
          :third_grade => { year => { tag => data }},
          :eighth_grade => {}, :asian => {}, :all => {},
          :pacific_islander => {}, :native_american => {}, :hispanic => {},
          :two_or_more => {}, :white => {}, :black => {} })
        @swtests[name] = swtest
      end
    end
  end

  def find_by_name(name)
    @swtests[name.upcase]
  end

  def clean_data(row)
    academic_tags = ["Math", "Reading", "Writing"]
    racial_tags = ["All Students", "Asian", "Black", "Native American",
      "Two or more", "White", "Hawaiian/Pacific Islander", "Hispanic"]
    chosen_header = :score if academic_tags.include?(row.to_s.split(",")[1])
    chosen_header = :race_ethnicity if racial_tags.include?(row.to_s.split(",")[1])
    year = clean_year(row[:timeframe])
    tag = clean_tag(row[chosen_header])
    data = clean_percent(row[:data])
    [year, tag, data]
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

  def clean_tag(tag)
    return :all if tag.downcase == "all students"
    return :pacific_islander if tag.downcase == "hawaiian/pacific islander"
    return :native_american if tag.downcase == "native american"
    return :two_or_more if tag.downcase == "two or more"
    tag.downcase.to_sym
  end

  def clean_percent(data)
    return 0.0 if data.upcase == "N/A" || data.upcase == "LNE"
    return (data + '.').ljust(7, "0").to_f if data == "0" || data == "1"
    return data.ljust(7, "0").to_f if data.chars.count < 7
    data.to_s.to_f
  end
end
