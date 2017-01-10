require_relative 'test_helper'
require './lib/statewide_test'
require './lib/statewide_test_repo'
require './lib/data_load'

class StatewideTestRepoTest < Minitest::Test
  include DataLoad
  attr_reader :str
  def setup
    @str = StatewideTestRepo.new
  end

  def test_it_is_a_statewide_test_repo
    assert_equal StatewideTestRepo, str.class
  end

  def test_has_collection_of_statewide_test_objects
    assert_equal Hash, str.swtests.class
    assert str.swtests.empty?
  end

  def test_clean_tag_returns_correct_symbols
    academic_tags = ["Math", "Reading", "Writing"]
    racial_tags = ["All Students", "Asian", "Black", "Native American",
      "Two or more", "White", "Hawaiian/Pacific Islander", "Hispanic"]
    expected_racial = [:all, :asian, :black, :native_american, :two_or_more,
      :white, :pacific_islander, :hispanic]
    expected_academic = [:math, :reading, :writing]

    expected_racial.zip(racial_tags).each do |pair|
      assert_equal pair[0], str.clean_tag(pair[1])
    end

    expected_academic.zip(academic_tags).each do |pair|
      assert_equal pair[0], str.clean_tag(pair[1])
    end
  end

  def test_can_load_data
    assert str.swtests.empty?
    str.load_data({
      :statewide_testing => {
    :third_grade => "./test/fixtures/3rd_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :eighth_grade => "./test/fixtures/8th_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :math => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Math.csv",
    :reading => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Reading.csv",
    :writing => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Writing.csv"
  }})
    assert_equal 5, str.swtests.count
    names = ['COLORADO', 'ACADEMY 20', 'ADAMS COUNTY 14',
      'ADAMS-ARAPAHOE 28J', 'BIG SANDY 100J']
    assert_equal names.sort, str.swtests.keys.sort
  end

  def test_can_find_swt_by_name
    str.load_data({
      :statewide_testing => {
    :third_grade => "./test/fixtures/3rd_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :eighth_grade => "./test/fixtures/8th_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :math => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Math.csv",
    :reading => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Reading.csv",
    :writing => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Writing.csv"
  }})
    assert_equal 'ACADEMY 20', str.find_by_name('ACADEMY 20').name
    assert_equal StatewideTest, str.find_by_name('ACADEMY 20').class
    assert_equal 'ADAMS COUNTY 14', str.find_by_name('adamS countY 14').name
    assert_nil str.find_by_name('TURING SCHOOL')
  end

  def test_can_get_data_from_swt_object
    str.load_data({
      :statewide_testing => {
    :third_grade => "./test/fixtures/3rd_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :eighth_grade => "./test/fixtures/8th_grade_students_scoring_proficient_or_above_on_the_CSAP_TCAP.csv",
    :math => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Math.csv",
    :reading => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Reading.csv",
    :writing => "./test/fixtures/Average_proficiency_on_the_CSAP_TCAP_by_race_ethnicity_Writing.csv"
  }})
    st = str.find_by_name('ACADEMY 20')
    assert_equal 0.857, st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_in_delta 0.818,
    st.proficient_for_subject_by_race_in_year(:math, :asian, 2012), 0.005
  end
end
