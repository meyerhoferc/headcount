require_relative 'data_load'
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
    # add_third_grade_data(contents[:third_grade])
    # add_eighth_grade_data(contents[:eighth_grade])
    # add_math_data(contents[:math])
    # add_reading_data(contents[:reading])
    # add_writing_data(contents[:writing])
    contents.each_pair do |data_tag, file|
      add_data(data_tag, file)
    end
  end

  def add_data(tag, file)
    file.each do |row|
      name = row[:location].upcase
      year, tag, data = clean_data(row)
      # year is year in integer
      # tag is the symbol for grade or ethnicity
      # data is the percent in 3 digit float
      if @swtests.has_key?(name)
        swtest = @swtests[name]
        swtest.identifier[tag][year] = data
      else
        swtest = StatewideTest.new({ :name => name,
          :third_grade => { year[subject] => data}, #format
          :eighth_grade => {}, :asian => {}, :all => {},
          :pacific_islander => {}, :native_american => {}, :hispanic => {},
          :two_or_more => {}, :white => {}, :black => {} })
          # not sure if the hash will work this way, adding the third grade data first
          # I think it should because third grade is the first file put into the tagged_data hash
        @swtests[name] = swtest
      end
    end
  end

  def clean_data(row)
    # possible_tag_headers = [:score or :race_ethnicity]
    academic_tags = ["Math", "Reading", "Writing"]
    racial_tags = ["All Students", "Asian", "Black", "Native American",
      "Two or more", "White", "Hawaiian/Pacific Islander"]
    chosen_header = :score if academic_tags.include?(row.to_s.split(",")[1])
    chosen_header = :race_ethnicity if racial_tags.include?(row.to_s.split(",")[1])
    year = clean_year(row[:timeframe])
    tag = clean_tag(row[chosen_header])
    data = clean_percent(row[:data])
    [year, tag, data]
  end

  # def add_third_grade_data(file)
  #   file.each do |row|
  #     name = row[:location].upcase
  #     year, subject, data = third_grade_yearly(row) #clean data
  #     if @swtests.has_key?(name)
  #       @swtests[name].identifier[:third_grade][year] = data
  #     else
  #       swtest = StatewideTest.new({ :name => name,
  #         :third_grade => { year[subject] => data }, #format
  #         :eighth_grade => {}, :asian => {}, :all => {},
  #         :pacific_islander => {}, :native_american => {}, :hispanic => {},
  #         :two_or_more => {}, :white => {}, :black => {} })
  #       @swtests[name] = swtest
  #     end
  #   end
  # end
  #
  # def add_eighth_grade_data(file)
  # end
  #
  # def add_math_data(file)
  # end
  #
  # def add_reading_data(file)
  # end
  #
  # def add_writing_data(file)
  # end
end
