require_relative 'test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test
  attr_reader :st, :asian, :all,  :third_grade, :eighth_grade, :black,
    :hpi, :native_american, :white, :hispanic, :two_or_more
  def setup
    third_grade_2008 = { :math => 0.857, :reading => 0.866, :writing => 0.671 }
    third_grade_2009 = { :math => 0.824, :reading => 0.862, :writing => 0.706 }
    third_grade_2010 = { :math => 0.849, :reading => 0.864, :writing => 0.662 }
    third_grade_2011 = { :math => 0.819, :reading => 0.867, :writing => 0.678 }
    third_grade_2012 = { :math => 0.83, :reading => 0.87, :writing => 0.65517 }
    third_grade_2013 = { :math => 0.8554, :reading => 0.85923, :writing => 0.6687 }
    third_grade_2014 = { :math => 0.8345, :reading => 0.83101, :writing => 0.63942 }
    @third_grade = { 2008 => third_grade_2008, 2009 => third_grade_2009,
      2010 => third_grade_2010, 2011 => third_grade_2011,
      2012 => third_grade_2012, 2013 => third_grade_2013 }

    eighth_grade_2008 = { :math => 0.64, :reading => 0.843, :writing => 0.734 }
    eighth_grade_2009 = { :math => 0.656, :reading => 0.825, :writing => 0.701 }
    eighth_grade_2010 = { :math => 0.672, :reading => 0.863, :writing => 0.754 }
    eighth_grade_2011 = { :math => 0.65339, :reading => 0.83221, :writing => 0.74579 }
    eighth_grade_2012 = { :math => 0.68197, :reading => 0.83352, :writing => 0.73839 }
    eighth_grade_2013 = { :math => 0.6613, :reading => 0.85286, :writing => 0.75069 }
    eighth_grade_2014 = { :math => 0.68496, :reading => 0.827, :writing => 0.74789 }
    @eighth_grade = { 2008 => eighth_grade_2008, 2009 => eighth_grade_2009,
      2010 => eighth_grade_2010, 2011 => eighth_grade_2011,
      2012 => eighth_grade_2012, 2013 => eighth_grade_2013,
      2014 => eighth_grade_2014 }

    asian_2011 = { :math => 0.8169, :reading => 0.8976, :writing => 0.8268 }
    asian_2012 = { :math => 0.8182, :reading => 0.89328, :writing => 0.8083 }
    asian_2013 = { :math => 0.8053, :reading => 0.90193, :writing => 0.8109 }
    asian_2014 = { :math => 0.8, :reading => 0.85531, :writing => 0.7894 }
    @asian = { 2011 => asian_2011, 2012 => asian_2012, 2013 => asian_2013,
      2014 => asian_2014 }

    all_2011 = {:math => 0.68, :reading => 0.83, :writing => 0.7192}
    all_2012 = {:math => 0.6894, :reading => 0.84585, :writing => 0.70593}
    all_2013 = {:math => 0.69683, :reading => 0.84505, :writing => 0.72029}
    all_2014 = {:math => 0.69944, :reading => 0.84127, :writing => 0.71583}
    @all = { 2011 => all_2011, 2012 => all_2012,
      2013 => all_2013, 2014 => all_2014}

    black_2011 = { :math => 0.4246, :reading => 0.662, :writing => 0.5152 }
    black_2012 = { :math => 0.4248, :reading => 0.69469, :writing => 0.5044 }
    black_2013 = { :math => 0.4404, :reading => 0.66951, :writing => 0.4819 }
    black_2014 = { :math => 0.4205, :reading => 0.70387, :writing => 0.5194 }
    @black = { 2011 => black_2011, 2012 => black_2012,
      2013 => black_2013, 2014 => black_2014}

    hpi_2011 = {:math => 0.5686, :reading => 0.7451, :writing => 0.7255}
    hpi_2012 = {:math => 0.5714, :reading => 0.83333, :writing => 0.6833}
    hpi_2013 = {:math => 0.6833, :reading => 0.86667, :writing => 0.7167}
    hpi_2014 = {:math => 0.6818, :reading => 0.93182, :writing => 0.7273}
    @hpi = { 2011 => hpi_2011, 2012 => hpi_2012, 2013 => hpi_2013, 2014 => hpi_2014}

    hispanic_2011 = { :math => 0.5681, :reading => 0.7486, :writing => 0.6068 }
    hispanic_2012 = { :math => 0.5722, :reading => 0.77167, :writing => 0.5978 }
    hispanic_2013 = { :math => 0.5883, :reading => 0.77278, :writing => 0.623 }
    hispanic_2014 = { :math => 0.6048, :reading => 0.00778, :writing => 0.6244 }
    @hispanic = { 2011 => hispanic_2011, 2012 => hispanic_2012,
      2013 => hispanic_2013, 2014 => hispanic_2014}

    native_american_2011 = { :math => 0.6143, :reading => 0.8169, :writing => 0.6 }
    native_american_2012 = { :math => 0.5714, :reading => 0.78571, :writing => 0.5893 }
    native_american_2013 = { :math => 0.5932, :reading => 0.81356, :writing => 0.6102 }
    native_american_2014 = { :math => 0.5439, :reading => 0.00724, :writing => 0.6207 }
    @native_american = { 2011 => native_american_2011, 2012 => native_american_2012,
      2013 => native_american_2013, 2014 => native_american_2014 }

    two_or_more_2011 = { :math => 0.6772, :reading => 0.8419, :writing => 0.7274 }
    two_or_more_2012 = { :math => 0.6899, :reading => 0.84584, :writing => 0.7186 }
    two_or_more_2013 = { :math => 0.6967, :reading => 0.88582, :writing => 0.7474 }
    two_or_more_2014 = { :math => 0.6932, :reading => 0.00859, :writing => 0.7317 }
    @two_or_more = { 2011 => two_or_more_2011, 2012 => two_or_more_2012,
      2013 => two_or_more_2013, 2014 => two_or_more_2014 }

    white_2011 = { :math => 0.7065, :reading => 0.8513, :writing => 0.7401 }
    white_2012 = { :math => 0.7135, :reading => 0.86189, :writing => 0.7262 }
    white_2013 = { :math => 0.7208, :reading => 0.86083, :writing => 0.7406 }
    white_2014 = { :math => 0.723, :reading => 0.00856, :writing => 0.7348 }
    @white = { 2011 => white_2011, 2012 => white_2012,
      2013 => white_2013, 2014 => white_2014}

    @st = StatewideTest.new({ :name => 'ACADEMY 20', :third_grade => @third_grade,
      :eighth_grade => @eighth_grade, :asian => @asian, :all => @all, :hpi => @hpi,
      :native_american => @native_american, :hispanic => @hispanic,
      :two_or_more => @two_or_more, :white => @white, :black => @black })
  end

  def test_it_is_a_statewide_test
    assert_equal StatewideTest, st.class
  end

  def test_knows_its_name
    assert_equal 'ACADEMY 20', st.name
  end

  def test_can_return_all_third_grade_data
    assert_equal third_grade, st.identifier[:third_grade]
  end

  def test_knows_keys_in_identifier
    expected = [:name, :all, :asian, :two_or_more, :black, :third_grade,
      :eighth_grade, :white, :hpi, :hispanic, :native_american]
    assert_equal expected.sort, st.identifier.keys.sort
  end

  def test_proficient_by_grade_returns_years_and_scores
    assert_equal third_grade, st.proficient_by_grade(3)
    assert_equal eighth_grade, st.proficient_by_grade(8)
    assert_raises(UnknownDataError) { st.proficient_by_grade(6) }
  end

  def test_proficient_for_subject_by_grade_in_year_returns_data
    assert_equal 0.857, st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_raises(UnknownDataError) { st.proficient_for_subject_by_grade_in_year(:math, 6, 2008) }
    assert_raises(UnknownDataError) { st.proficient_for_subject_by_grade_in_year(:science, 3, 2008) }
  end

  def test_proficient_for_subject_by_race_in_year_returns_data_or_error
    assert_raises(UnknownRaceError) { st.proficient_for_subject_by_race_in_year(:math, :purple, 2012) }
    assert_in_delta 0.818,
    st.proficient_for_subject_by_race_in_year(:math, :asian, 2012), 0.005
  end

  def test_proficient_by_race_or_ethnicity_returns_years_and_scores_for_race
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
     2012 => {math: 0.818, reading: 0.893, writing: 0.808},
     2013 => {math: 0.805, reading: 0.901, writing: 0.810},
     2014 => {math: 0.800, reading: 0.855, writing: 0.789}}
    assert_raises(UnknownRaceError) { st.proficient_by_race_or_ethnicity(:purple) }
    actual = st.proficient_by_race_or_ethnicity(:asian)
    expected.each_pair do |year, subjects|
      subjects.each_pair do |subject, data|
        assert_in_delta data, actual[year][subject], 0.005
      end
    end
  end
end
