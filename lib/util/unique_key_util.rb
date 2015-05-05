class UniqueKeyUtil

  class << self
    def exitsUnique?(key)
      $redis.get(key) != nil
    end

    def setUnique(key)
      if exitsUnique?(key) == false
        $redis.set(key,1)
      end
    end

    def delUnique(key)
      $redis.del(key)
    end
  end

end
