require 'csv'
module DataLoad
  def load_files(files)
    kindergarten = files[:enrollment][:kindergarten]
    kindergarten = CSV.open kindergarten,
    headers: true, header_converters: :symbol

    high_school_graduation = data[:enrollment][:high_school_graduation]
    high_school_graduation = CSV.open high_school_graduation,
    headers: true, header_converters: :symbol

    [kindergarten, high_school_graduation]
  end
end
