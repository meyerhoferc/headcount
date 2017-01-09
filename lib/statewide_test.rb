require_relative 'unknown_data_error'
require_relative 'unknown_race_error'

class StatewideTest
  attr_reader :identifier
  def initialize(identifier)
    @identifier = identifier
  end

  def name
    @identifier.fetch(:name, UnknownDataError)
  end

  def proficient_by_grade(grade)
    available_grades = [3, 8]
    if grade == 3
      @identifier[:third_grade]
    elsif grade == 8
      @identifier[:eighth_grade]
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    available_subjects = [:math, :reading, :writing]
    available_grades = [3, 8]
    if  !available_grades.include?(grade) || !available_subjects.include?(subject)
      raise UnknownDataError
    end
    grade = :third_grade if grade == 3
    grade = :eighth_grade if grade == 8
    @identifier[grade][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    available_subjects = [:math, :reading, :writing]
    races = [:all, :white, :black, :hispanic, :hpi, :asian,
      :native_american, :two_or_more]
    if !races.include?(race)
      raise UnknownRaceError
    elsif !available_subjects.include?(subject)
      raise UnknownDataError
    else
      @identifier[race][year][subject]
    end
  end

  def proficient_by_race_or_ethnicity(race)
    races = [:all, :white, :black, :hispanic, :hpi, :asian,
      :native_american, :two_or_more]
    if !races.include?(race)
      raise UnknownRaceError
    end
    @identifier[race]
  end
end
