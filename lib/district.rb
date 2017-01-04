class District
  attr_reader :identifier
  def initialize
    @identifier = Hash.new
  end

  def name
    identifier[:name]
  end
end
