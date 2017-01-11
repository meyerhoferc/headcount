module DataCleaner
  def clean_year(year)
    year = year.chars
    return year.join.ljust(4, "0").to_i if year.count < 4
    if year[0] == "0"
      year.shift
      return year.join.ljust(4, "0").to_i
    end
    if year[-1] == "0"
      year.pop
      return year.join.ljust(4, "0").to_i
    end
    year.join.to_i
  end

  def clean_range(range)
    digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    characters = range.to_s.chars
    new_range = characters.reject { |data| data if !digits.include?(data) }
    [new_range[0..3].join.to_i, new_range[4..7].join.to_i]
  end

  def clean_percent(data)
    return 0.0 if data.nil?
    return data if ["N/A", "LNE", "#VALUE!"].include?(data.upcase)
    return (data + '.').ljust(7, "0").to_f if data == "0" || data == "1"
    return data.ljust(7, "0").to_f if data.chars.count < 7
    data.to_s.to_f.round(3)
  end

  def clean_salary(salary)
    salary.to_i
  end
end
