require 'pry'

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
		(enrollment_data.reduce(:+) / enrollment_data.count).round(5)
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

	def kindergarten_participation_against_high_school_graduation(district_name)
		high_school = high_school_graduation_rate_variation(district_name, :against => 'COLORADO')
		kindergarten = kindergarten_participation_rate_variation(district_name, :against => 'COLORADO')
		(kindergarten / high_school).round(3)
	end

	def find_enrollment(district_name)
		raise(NameError) if !dr.districts.has_key?(district_name)
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
end
