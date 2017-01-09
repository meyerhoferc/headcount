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
    add_third_grade_data(contents[:third_grade])
    add_eighth_grade_data(contents[:eighth_grade])
    add_math_data(contents[:math])
    add_reading_data(contents[:reading])
    add_writing_data(contents[:writing])
  end

  def add_third_grade_data(file)
    file.each do |row|
      name = row[:location].upcase
      year, subject, data = third_grade_yearly(row) #clean data
      if @swtests.has_key?(name)
        @swtests[name].identifier[:third_grade][year] = data
      else
        swtest = StatewideTest.new({ :name => name,
          :third_grade => { year[subject] = data }, #format
          :eighth_grade => {}, :asian => {}, :all => {},
          :pacific_islander => {}, :native_american => {}, :hispanic => {},
          :two_or_more => {}, :white => {}, :black => {} })
        @swtests[:name] = swtest
      end
    end
  end

  def add_eighth_grade_data(file)
  end

  def add_math_data(file)
  end

  def add_reading_data(file)
  end

  def add_writing_data(file)
  end
end
