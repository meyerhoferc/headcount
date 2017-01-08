require_relative 'test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repo'

class StatewideTestTest < Minitest::Test
  attr_reader :st, :math, :reading, :writing, :third_grade, :eighth_grade
  def setup
    third_grade_math = { 2008 => 0.857, 2009 => 0.824, 2010 => 0.849,
      2011 => 0.819, 2012 => 0.83, 2013 => 0.8554, 2014 => 0.8345}

    third_grade_reading = { 2008 => 0.866, 2009 => 0.862, 2010 => 0.864,
      2011 => 0.867, 2012 => 0.87, 2013 => 0.85923, 2014 => 0.83101}

    third_grade_writing = { 2008 => 0.671, 2009 => 0.706, 2010 => 0.662,
      2011 => 0.678, 2012 => 0.65517, 2013 => 0.6687, 2014 => 0.63942}

    @third_grade = { :math => third_grade_math,
      :reading => third_grade_reading,:writing => third_grade_writing }

    eighth_grade_math = { 2008 => 0.64, 2009 => 0.656, 2010 => 0.672,
      2011 => 0.65339, 2012 => 0.68197, 2013 => 0.6613, 2014 => 0.68496}
    eighth_grade_reading = { 2008 => 0.843, 2009 => 0.825, 2010 => 0.863,
      2011 => 0.83221, 2012 => 0.83352, 2013 => 0.85286, 2014 => 0.827}
    eighth_grade_writing = { 2008 => 0.734, 2009 => 0.701, 2010 => 0.754,
      2011 => 0.74579, 2012 => 0.73839, 2013 => 0.75069, 2014 => 0.74789}

    @eighth_grade = { :math => eighth_grade_math,
      :reading => eighth_grade_reading, :writing => eighth_grade_writing }

    all_math = { 2011 => 0.68, 2012 => 0.6894,
      2013 => 0.69683, 2014 => 0.69944 }
    asian_math = { 2011 => 0.8169, 2012 => 0.8182,
      2013 => 0.8053, 2014 => 0.8 }
    black_math = { 2011 => 0.4246, 2012 => 0.4248,
      2013 => 0.4404, 2014 => 0.4205 }
    hpi_math = { 2011 => 0.5686, 2012 => 0.5714,
      2013 => 0.6833, 2014 => 0.6818 }
    hispanic_math = { 2011 => 0.5681, 2012 => 0.5722,
      2013 => 0.5883, 2014 => 0.6048 }
    native_american_math = { 2011 => 0.6143, 2012 => 0.5714,
      2013 => 0.5932, 2014 => 0.5439 }
    two_or_more_math = { 2011 => 0.6772, 2012 => 0.6899,
      2013 => 0.6967, 2014 => 0.6932 }
    white_math = { 2011 => 0.7065, 2012 => 0.7135,
      2013 => 0.7208, 2014 => 0.723 }

    @math = { :all => all_math, :asian => asian_math, :black => black_math,
      :hawaiian_pacific_islander => hpi_math, :hispanic => hispanic_math,
      :native_american => native_american_math, :two_or_more => two_or_more_math,
      :white => white_math}

    all_reading = { 2011 => 0.83, 2012 => 0.84585,
      2013 => 0.84505, 2014 => 0.84127 }
    asian_reading = { 2011 => 0.8976, 2012 => 0.89328,
      2013 => 0.90193, 2014 => 0.85531 }
    black_reading ={ 2011 => 0.662, 2012 => 0.69469,
      2013 => 0.66951, 2014 => 0.70387 }
    hpi_reading = { 2011 => 0.7451, 2012 => 0.83333,
      2013 => 0.86667, 2014 => 0.93182 }
    hispanic_reading = { 2011 => 0.7486, 2012 => 0.77167,
      2013 => 0.77278, 2014 => 0.00778 }
    native_american_reading = { 2011 => 0.8169, 2012 => 0.78571,
      2013 => 0.81356, 2014 => 0.00724 }
    two_or_more_reading = { 2011 => 0.8419, 2012 => 0.84584,
      2013 => 0.88582, 2014 => 0.00859 }
    white_reading = { 2011 => 0.8513, 2012 => 0.86189,
      2013 => 0.86083, 2014 => 0.00856 }

    @reading = { :all => all_reading, :asian => asian_reading,
      :black => black_reading, :hawaiian_pacific_islander => hpi_reading,
      :hispanic => hispanic_reading, :native_american => native_american_reading,
      :two_or_more => two_or_more_reading, :white => white_reading }

    all_writing = { 2011 => 0.7192, 2012 => 0.70593,
      2013 => 0.72029, 2014 => 0.71583 }
    asian_writing = { 2011 => 0.8268, 2012 => 0.8083,
      2013 => 0.8109, 2014 => 0.7894 }
    black_writing = { 2011 => 0.5152, 2012 => 0.5044,
      2013 => 0.4819, 2014 => 0.5194 }
    hpi_writing = { 2011 => 0.7255, 2012 => 0.6833,
      2013 => 0.7167, 2014 => 0.7273 }
    hispanic_writing = { 2011 => 0.6068, 2012 => 0.5978,
      2013 => 0.623, 2014 => 0.6244 }
    native_american_writing = { 2011 => 0.6, 2012 => 0.5893,
      2013 => 0.6102, 2014 => 0.6207 }
    two_or_more_writing = { 2011 => 0.7274, 2012 => 0.7186,
      2013 => 0.7474, 2014 => 0.7317 }
    white_writing = { 2011 => 0.7401, 2012 => 0.7262,
      2013 => 0.7406, 2014 => 0.7348 }

    @writing = :writing => { :all => all_writing, :asian => asian_writing,
      :black => black_writing, :hawaiian_pacific_islander => hpi_writing,
      :hispanic => hispanic_writing, :native_american => native_american_writing,
      :two_or_more => two_or_more_writing, :white => white_writing }

    @st = StatewideTest({ :name => 'ACADEMY 20', :third_grade => third_grade,
      :eighth_grade => eighth_grade, :math => math , :reading => reading,
      :writing => writing })
  end

  def test_it_is_a_statewide_test
    skip
    assert_equal StatewideTest, st.class
  end

  def test_knows_its_name
    skip
    assert_equal 'ACADEMY 20', st.name
  end

  def test_can_return_all_math_data
    skip
    assert_equal math, st.identifier[:math]
  end

  def test_can_return_all_third_grade_data
    skip
    assert_equal third_grade, st.identifier[:third_grade]
  end

  def test_knows_keys_in_identifier
    skip
    assert_equal [:name, :math, :reading, :writing, :third_grade, :eighth_grade].sort, st.identifier.keys.sort 
  end

  def test_proficient_by_grade_returns_years_and_scores
    skip
    assert_equal third_grade, st.proficient_by_grade(3)
    assert_equal eighth_grade, st.proficient_by_grade(8)
  end

  def test_proficient_by_grade_returns_unknwon_data_error
    skip
    #if not grades 3 or 8
    assert_raises UnknownDataError, st.proficient_by_grade(6)
  end

  def test_proficient_for_subject_by_grade_in_year_returns_data
    skip
    #takes 3 args => 3 digit Float or UnknownGradeError
    assert_equal 0.857, st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_proficient_for_subject_by_race_in_year_returns_data_or_error
    skip
    assert_raises UnknownRaceError, st.proficient_for_subject_by_race_in_year(:math, :purple, 2012)
    assert_equal 0.818, st.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end

  def test_proficient_by_race_or_ethnicity_returns_years_and_scores_for_race
    skip
    #takes (:race), UnknownRaceError if not in array of races
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
     2012 => {math: 0.818, reading: 0.893, writing: 0.808},
     2013 => {math: 0.805, reading: 0.901, writing: 0.810},
     2014 => {math: 0.800, reading: 0.855, writing: 0.789},
    }
    #verify the hash above--might be incorrect
    #takes 3 args => 3 digit float or UnknownRaceError
    assert_raises UnknownRaceError, st.proficient_by_race_or_ethnicity(:purple)
    assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end
end
