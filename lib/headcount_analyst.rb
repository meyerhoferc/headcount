require_relative 'unknown_data_error'
require_relative 'insufficient_information_error'

class HeadcountAnalyst
	attr_reader :dr
	def initialize(dr)
		@dr = dr
		@swtests_year_growth = Hash.new
	end
	def 

		
	end

	def find_average(district_name, data_tag)
		enrollment = find_enrollment(district_name)
		enrollment_data = enrollment.kindergarten_participation_by_year if data_tag == :kindergarten
		enrollment_data = enrollment.graduation_rate_by_year if data_tag == :high_school_graduation
		enrollment_data = enrollment_data.map { |year, value| value }
		undesired = ["N/A", "LNE", "#VALUE!"]
		enrollment_data = enrollment_data.reject { |data| undesired.include?(data) }
		unless enrollment_data.nil?
			(enrollment_data.reduce(:+) / enrollment_data.count).round(5)
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
		compare_averages(district_name, comparison[:against], :high_school_graduation)
	end

	def kindergarten_participation_against_high_school_graduation(district_name, comparison = {:against => 'COLORADO'})
		high_school = high_school_graduation_rate_variation(district_name, :against => 'COLORADO')
		kindergarten = kindergarten_participation_rate_variation(district_name, :against => 'COLORADO')
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

	def kindergarten_participation_correlates_with_high_school_graduation(settings)
		name = settings[:for] if settings.has_key?(:for)
		name = settings[:across] if settings.has_key?(:across)
		if name == 'STATEWIDE'
			check_statewide
		elsif name.class == Array
			check_across_districts(name)
		else
			ratio = kindergarten_participation_against_high_school_graduation(name, settings)
			ratio <= 1.5 && ratio >= 0.6
		end
	end

	def check_across_districts(districts)
		ratios = []
		districts.each do |district|
			ratios << kindergarten_participation_against_high_school_graduation(district)
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
		earliest = data[0]
		latest = data[-1]
		((latest[1] - earliest[1]) / (latest[0] - earliest[0])).round(3)
	end

	def year_and_percentage(settings, swtest)
		#needs more checks for setup
		subject = settings[:subject]
		grade = settings[:grade]
		all_student_data = swtest.identifier[:all]
		years_percentages = []
		all_student_data.each_pair do |year, subject_data|
			data = subject_data[subject]
			years_percentages << [year, data]
		end
		years_percentages
	end

	def top_statewide_test_year_over_year_growth(settings)
		raise(InsufficientInformationError) if settings[:grade].nil?
		raise(UnknownDataError) if ![3, 8].include?(settings[:grade])
		calculate_all_year_over_year_growths(settings)
		if settings[:top].nil?
			@swtests_year_growth.sort_by { |name, growth| growth }.reverse.first
		else
			count = settings[:top] - 1
			sorted = @swtests_year_growth.sort_by { |name, growth| growth }.reverse
			(0..count).to_a.map { |i| sorted[i] }
		end
	end

	def calculate_all_year_over_year_growths(settings)
		weighting = settings.has_key?(:weighting)
		#assuming no weighting for now
		dr.str.swtests.each_pair do |name, swtest|
			unless name == 'COLORADO'
				data = year_and_percentage(settings, swtest)
				@swtests_year_growth[name] = year_over_year_growth(data)
			end
		end
	end
end
