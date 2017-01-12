require_relative 'unknown_data_error'
require_relative 'insufficient_information_error'

class HeadcountAnalyst
  attr_reader :dr,
              :swtests_year_growth
  def initialize(dr)
    @dr = dr
    @swtests_year_growth = Hash.new
  end

  def find_average(district_name, data_tag)
    enrollment = find_enrollment(district_name)
    data = choose_data(enrollment, data_tag)
    data = data.map { |year, value| value }
    undesired = ["N/A", "LNE", "#VALUE!"]
    data = data.reject { |data| undesired.include?(data) }
    unless data.nil?
      (data.reduce(:+) / data.count).round(5)
    end
  end

  def choose_data(enrollment, data_tag)
    if data_tag == :kindergarten
      enrollment.kindergarten_participation_by_year
    else
      enrollment.graduation_rate_by_year
    end
  end

  def compare_averages(district_1_name, district_2_name, data_tag)
    district_1_average = find_average(district_1_name, data_tag)
    district_2_average = find_average(district_2_name, data_tag)
    (district_1_average / district_2_average).round(3)
  end

  def kindergarten_participation_rate_variation(district_name, comparison)
    compare_averages(district_name, comparison[:against], :kindergarten)
  end

  def high_school_graduation_rate_variation(district_name, comparison)
    compare_averages(district_name, comparison[:against],
      :high_school_graduation)
  end

  def kindergarten_participation_against_high_school_graduation(district_name,
    comparison = {:against => 'COLORADO'})
    high_school = high_school_graduation_rate_variation(district_name,
      :against => 'COLORADO')
    kindergarten = kindergarten_participation_rate_variation(district_name,
      :against => 'COLORADO')
    (kindergarten / high_school).round(3)
  end

  def find_enrollment(district_name)
    raise(UnknownDataError) if !dr.districts.has_key?(district_name)
    dr.er.find_by_name(district_name)
  end

  def kindergarten_participation_rate_variation_trend(district_name, comparison)
    enrollment_1 = find_enrollment(district_name)
    enrollment_2 = find_enrollment(comparison[:against])
    enrollment_data_1 = enrollment_1.kindergarten_participation_by_year
    enrollment_data_2 = enrollment_2.kindergarten_participation_by_year
    result = {}
    enrollment_data_1.each_pair do |year, value|
      ratio = (value / enrollment_data_2[year]).round(3)
      result[year] = ratio
    end
    result.sort.to_h
  end

  def kindergarten_participation_correlates_with_high_school_graduation(setting)
    name = setting[:for] if setting.has_key?(:for)
    name = setting[:across] if setting.has_key?(:across)
    if name == 'STATEWIDE'
      check_statewide
    elsif name.class == Array
      check_across_districts(name)
    else
      ratio = kindergarten_participation_against_high_school_graduation(name,
        setting)
      ratio <= 1.5 && ratio >= 0.6
    end
  end

  def check_across_districts(districts)
    ratios = []
    districts.each do |dtrct|
      ratios << kindergarten_participation_against_high_school_graduation(dtrct)
    end
    check_in_range(ratios)
  end

  def check_statewide
    ratios = []
    dr.er.enrollments.each_pair do |name, enrollment|
      ratios << kindergarten_participation_against_high_school_graduation(name)
    end
    check_in_range(ratios)
  end

  def check_in_range(ratios)
    number = ratios.count do |ratio|
      ratio <= 1.5 && ratio >= 0.6
    end
    number / ratios.count >= 0.7
  end

  def year_over_year_growth(data)
    clean_data = clean_year_and_percentage_data(data)
    return 0 if clean_data.empty?
    earliest = clean_data[0]
    latest = clean_data[-1]
    return if earliest == latest
    ((latest[1] - earliest[1]) / (latest[0] - earliest[0])).round(3)
  end

  def clean_year_and_percentage_data(data)
    undesired = ["N/A", "LNE", "#VALUE!", nil, Float::NAN]
    clean_data = data.reject { |data| undesired.include?(data[1]) }
    clean_data = clean_data.reject { |data| data[0].class != Fixnum }
    clean_data = clean_data.reject { |data| data[1].nan? unless data[1] == 0 }
  end

  def year_and_percentage(settings, swtest)
    subjects = [:math, :reading, :writing] if settings[:subject].nil?
    subject, grade = current_settings(settings)
    all_student_data = swtest.identifier[grade]
    years_percentages = []
    all_student_data.each_pair do |year, subject_data|
      data = subject_data[subject]
      if data == 0.0
        data = 0
      end
      years_percentages << [year, data]
    end
    years_percentages
  end

  def current_settings(settings)
    subject = settings[:subject] if !settings[:subject].nil?
    grade = :third_grade if settings[:grade] == 3
    grade = :eighth_grade if settings[:grade] == 8
    [subject, grade]
  end

  def top_statewide_test_year_over_year_growth(settings)
    raise(InsufficientInformationError) if settings[:grade].nil?
    raise(UnknownDataError) if ![3, 8].include?(settings[:grade])
    calculate_all_year_over_year_growths(settings)
    if settings[:top].nil?
      @swtests_year_growth.delete_if { |name, growth| growth.nil? }
      @swtests_year_growth.sort_by { |name, growth| growth }.reverse.first
    else
      count = settings[:top] - 1
      @swtests_year_growth.delete_if { |name, growth| growth.nil? }
      sorted = @swtests_year_growth.sort_by { |name, growth| growth }.reverse
      (0..count).to_a.map { |i| sorted[i] }
    end
  end

  def calculate_all_year_over_year_growths(settings)
    swtests = dr.str.swtests
    swtests.each_pair do |name, swtest|
      unless name == 'COLORADO'
        if settings[:subject].nil?
          all_subjects(swtest, settings)
        else
          data = year_and_percentage(settings, swtest)
          @swtests_year_growth[name] = year_over_year_growth(data)
        end
      end
    end
  end

  def all_subjects(swtest, settings)
    weighting = determine_weight_settings(settings)
    subjects = [:math, :reading, :writing]
    percentages = []
    subjects.each do |subject|
      current_settings = {:grade => settings[:grade], :subject => subject}
      data = year_and_percentage(current_settings, swtest)
      percentages << year_over_year_growth(data)
      weighted_percentage = weighted_percentages(percentages, weighting)
      @swtests_year_growth[swtest.name] = weighted_percentage
    end
  end

  def determine_weight_settings(settings)
    if settings[:weighting].nil?
      weighting = { :math => 1, :reading => 1, :writing => 1}
    else
      raise(UnknownDataError) if settings[:weighting].values.reduce(:+) != 1
      weighting = settings[:weighting]
    end
  end

  def weighted_percentages(percentages, weighting)
    percentages = percentages.reject do |data|
      data.nan? unless data == 0 || data.nil?
      data.nil?
    end
    return 0 if percentages.count != 3
    weighted_percentages = percentages.map do |percent|
      weight = weighting[:math] if percent == percentages[0]
      weight = weighting[:reading] if percent == percentages[1]
      weight = weighting[:writing] if percent == percentages[2]
      3 * weight * percent
    end
    weighted_percentages.reduce(:+)/weighted_percentages.count
  end
end
