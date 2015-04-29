class UniqueKeyUtil

  class << self
    def exitsUnique?(key)
      $redis.exits(key)
    end

    def setUnique(key)
      if isUnique?(key) == false
        $redis.set(key,1)
      end
    end

    def delUnique(key)
      $redis.del(key)
    end
  end

end