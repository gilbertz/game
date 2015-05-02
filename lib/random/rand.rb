def redpack_rand(n, sum)
  rarray = Array(1..sum-1).sample(n-1).sort
  rarray << sum
  res = []
  prev = 0 
  rarray.each do |e|
   res << e - prev
   prev = e 
  end
  res
end
