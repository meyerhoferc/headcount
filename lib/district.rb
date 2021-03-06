require_relative 'district_repository'

class District
  attr_reader :identifier

  def initialize(identifier)
    @identifier = identifier
  end

  def name
    identifier[:name]
  end

  def repo
    identifier[:repo]
  end

  def enrollment
    dr = repo
    current_name = name
    dr.er.find_by_name(current_name)
  end

  def statewide_test
    dr = repo
    dr.str.find_by_name(name)
  end

  def economic_profile
    dr = repo
    dr.epr.find_by_name(name)
  end
end
