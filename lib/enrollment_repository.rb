require 'csv'
require_relative 'enrollment'
require_relative 'data_load'
require_relative 'data_cleaner'

class EnrollmentRepository
  include DataLoad
  include DataCleaner
  attr_reader :enrollments
  def initialize
    @enrollments = Hash.new
  end

  def load_data(data)
    contents = load_files(data)
    kindergarten = contents[:kindergarten]
    high_school_graduation = contents[:high_school_graduation]
    enrollment_maker(kindergarten, high_school_graduation)
  end

  def enrollment_maker(kindergarten, high_school_graduation)
    add_kindergarten_participation_data(kindergarten)
    add_high_school_graduation_data(high_school_graduation)
  end

  def add_kindergarten_participation_data(file)
    file.each do |row|
      name = row[:location].upcase
      year, occupancy = kindergarten_participation_yearly(row)
      if @enrollments.has_key?(name)
        occupancy = 0 if occupancy.to_s == "N/A" || occupancy.to_s.chars[-1] == "!"
        @enrollments[name].identifier[:kindergarten_participation][year] = occupancy
      else
        enrollment = Enrollment.new({ :name => name,
          :kindergarten_participation => { year => occupancy },
          :high_school_graduation => {}})
          occupancy = 0 if occupancy.to_s == "N/A" || occupancy.to_s.chars[-1] == "!"
        @enrollments[name] = enrollment
      end
    end
  end

  def add_high_school_graduation_data(file)
    unless file.nil?
      file.each do |row|
        name = row[:location].upcase
        year, data = high_school_graduation_yearly(row)
        data = 0 if  data.to_s == "N/A" || data.to_s.chars[-1] == "!"
        @enrollments[name].identifier[:high_school_graduation][year] = data
      end
    end
  end

  def kindergarten_participation_yearly(row)
    [clean_year(row[:timeframe]).to_i, clean_percent(row[:data])]
  end

  def high_school_graduation_yearly(row)
    [clean_year(row[:timeframe]).to_i, clean_percent(row[:data])]
  end

  def find_by_name(name)
    name = name.upcase
    @enrollments[name]
  end
end
