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

  end



end