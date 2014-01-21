class ActiveSupport::TimeWithZone 
  def to_local(long = true, zone = 'Beijing') 
    self.utc.in_time_zone(zone).strftime("%F %#{long ? 'T' : 'R'}")
  end
end
