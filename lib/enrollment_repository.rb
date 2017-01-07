require 'csv'
require_relative 'enrollment'
require_relative 'data_load'
require 'pry'

class EnrollmentRepository
  include DataLoad
  attr_reader :enrollments
  def initialize
    @enrollments = Hash.new
  end

  def load_data(data)
    contents = load_files(data)
    kindergarten = contents[:kindergarten]
    high_school_graduation = contents[:high_school_graduation]
    #enrollment maker takes more args or maybe the hash or an array
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
        @enrollments[name].identifier[:kindergarten_participation][year] = occupancy
      else
        enrollment = Enrollment.new({ :name => name,
          :kindergarten_participation => { year => occupancy },
          :high_school_graduation => {}})
        @enrollments[name] = enrollment
      end
    end
  end

  def add_high_school_graduation_data(file)
    unless file.nil?
      file.each do |row|
        name = row[:location].upcase
        year, data = high_school_graduation_yearly(row)
          @enrollments[name].identifier[:high_school_graduation][year] = data
      end
    end
  end

  def kindergarten_participation_yearly(row)
    [clean_year(row[:timeframe]).to_i, clean_occupancy(row[:data]).to_f.round(3)]
  end

  def high_school_graduation_yearly(row)
    [clean_year(row[:timeframe]).to_i, clean_occupancy(row[:data]).to_f.round(3)]
  end

  def clean_occupancy(occupancy)
    return occupancy if occupancy.upcase == "N/A"
    return (occupancy + '.').ljust(7, "0") if occupancy == "0" || occupancy == "1"
    return occupancy.ljust(7, "0") if occupancy.chars.count < 7
    occupancy
  end

  def clean_year(year)
    year = year.chars
    return year.join.ljust(4, "0") if year.count < 4
    if year[0] == "0"
      year.shift
      return year.join.ljust(4, "0")
    end
    if year[-1] == "0"
      year.pop
      return year.join.ljust(4, "0")
    end
    year.join
  end

  def find_by_name(name)
    name = name.upcase
    @enrollments[name]
  end
end
