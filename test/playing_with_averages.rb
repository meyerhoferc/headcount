data = [0.39465, 0.33677, 0.27807, 0.24014, 0.53570, 0.59800, 0.64019,
  0.67200, 0.69500, 0.70263, 0.74118]

total = data.reduce(:+)
average = total / data.count
puts average.round(5)
