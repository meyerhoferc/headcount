require_relative 'enrollment'
require_relative 'enrollment_repository'
require_relative 'district_repository'
require_relative 'district'
require 'pry'


class HeadcountAnalyst
	attr_reader :dr
	def initialize(dr)
		@dr = identifier[:repo]
		#not sure how to reference the dr object? 
	end

	def kindergarten_participation_rate_variation(name, against_comparison)
		comparison = against_comparison[:against]
		district1 = dr.find_by_name(name)
		district2 = dr.find_by_name(comparison)
		rate = []
		dr.districts each do |district|
			#grab the district value, unless there is an error?
		end
		#another enumerable to grab participation
		#calculate the rate: total/value
		#shovel output into rate array 
	end
end