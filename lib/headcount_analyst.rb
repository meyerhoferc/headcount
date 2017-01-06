require_relative 'enrollment'
require_relative 'enrollment_repository'
require_relative 'district_repository'
require_relative 'district'
require 'pry'


class HeadcountAnalyst
	attr_reader :dr
	def initialize(dr)
		@dr = dr
		#not sure how to reference the dr object? 
	end

	def find_average(district_name)
		enrollment = dr.er.find_by_name(district_name)
		# ^^ finding an object inside of DR might need to be a method
		enrollment_data = enrollment.kindergarten_participation_by_year
		enrollment_data = enrollment_data.map { |year, value| value }
		enrollment_data.reduce(:+) / enrollment_data.count
	end

	def kindergarten_participation_rate_variation(name, against_comparison)
		comparison = against_comparison[:against]
		district1 = dr.er.find_by_name(name)
		district2 = dr.er.find_by_name(comparison)
		rate = []
		dr.districts each do |district|
			#grab the district value, unless there is an error?
		end
		#another enumerable to grab participation
		#calculate the rate: total/value
		#shovel output into rate array 
	end
end