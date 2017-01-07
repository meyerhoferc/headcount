require 'csv'
module DataLoad
  def load_files(file)
    files = file[:enrollment]
    tagged_files = files.each_pair do |data_tag, file|
      contents = CSV.open(file, headers: true, header_converters: :symbol)
      tagged_files[data_tag] = contents
    end
    tagged_files
  end
end
