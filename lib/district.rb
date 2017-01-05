class District
  attr_reader :identifier

  def initialize(identifier)
    @identifier = identifier
  end

  def name
    identifier[:name]
  end
end
