class Burl < ActiveRecord::Base
 def title
   
 end

 def beacon_name
   if self.beaconid
     b = Ibeacon.find self.beaconid
     return b.name if b
   end
 end
end
