require_relative 'enrollment'
require_relative 'enrollment_repository'
require_relative 'district_repository'
require_relative 'district'
require 'pry'


class HeadcountAnalyst
	attr_reader :dr
	def initialize(dr)
		@dr = dr
	end

	def find_average(district_name)
		enrollment = find_enrollment(district_name)
		enrollment_data = enrollment.kindergarten_participation_by_year
		enrollment_data = enrollment_data.map { |year, value| value }
		(enrollment_data.reduce(:+) / enrollment_data.count).round(5)
	end

	def compare_averages(district_1_name, district_2_name)
		district_1_average = find_average(district_1_name)
		district_2_average = find_average(district_2_name)
		(district_1_average / district_2_average).round(3)
	end

	def kindergarten_participation_rate_variation(district_name, against_comparison)
		comparison_district = against_comparison[:against]
		compare_averages(district_name, comparison_district)
	end

	def find_enrollment(district_name)
		dr.er.find_by_name(district_name)
	end
end
