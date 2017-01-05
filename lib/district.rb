class District
  attr_reader :identifier

  def initialize(identifier)
    @identifier = identifier #the object that is the repo it's in
  end

  def name
    identifier[:name]
  end
  # 
  # def enrollment
  #   dr = @identifier[:repo]
  #   dr.er.whatever we need
  # end
end
