require_relative 'unknown_data_error'

class HeadcountAnalyst
	attr_reader :dr
	def initialize(dr)
		@dr = dr
	end

	def find_average(district_name, data_tag)
		enrollment = find_enrollment(district_name)

		enrollment_data = enrollment.kindergarten_participation_by_year if data_tag == :kindergarten
		enrollment_data = enrollment.graduation_rate_by_year if data_tag == :high_school_graduation

		enrollment_data = enrollment_data.map { |year, value| value }
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
end
