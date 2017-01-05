require 'csv'
require_relative 'enrollment'
require 'pry'

class EnrollmentRepository
  attr_reader :enrollments
  def initialize
    @enrollments = Hash.new
  end

  def load_data(data)
    file_name = data[:enrollment][:kindergarten]
    contents = CSV.open file_name,
    headers: true, header_converters: :symbol
    enrollment_maker(contents)
  end

  def enrollment_maker(contents)
    contents.each do |row|
      name = row[:location].upcase
      year, occupancy = kindergarten_participation_yearly(row)
      if @enrollments.has_key?(name)
        @enrollments[name].identifier[:kindergarten_participation][year] = occupancy
      else
        enrollment = Enrollment.new({ :name => name,
          :kindergarten_participation => { year => occupancy }})
        @enrollments[name] = enrollment
      end
    end
  end

  def kindergarten_participation_yearly(row)
    [clean_year(row[:timeframe]), clean_occupancy(row[:data])]
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
