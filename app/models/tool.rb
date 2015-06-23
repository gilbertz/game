class Tool
  class << self
    def split_rand(total,num)
      return if total < 0
      return [total] if num < 0
      total = 100.0
      div = num
      average = (total / div).round
      sum = 0
      result = []
      1.step(div,1) {result.push 0}
      for i in 1...div
        if sum > 0
          max = 0
          min = 0
        end

      end

    end



    def get_rand_num(min,max,probability = 1)
      p = probability
      p = 1.0 if probability > 1.0
      middle = (max + min) / 2.0
      min_x = 0
      max_x = 0
      r = rand 100
      a = (p * 100).to_i
      if a > r
        min_x = middle
        max_x = max
      else
        min_x = min
        max_x = middle
      end

      rmin = (min_x * 100).to_i
      rmax = (max_x * 100).to_i

      inteveral = rmax - rmin
      x = rmin + rand(inteveral)
      x = x.to_f / 100.0
    end

  end



end