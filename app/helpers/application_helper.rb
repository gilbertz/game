module ApplicationHelper

def material_path(m)
  "/weitest/#{m.url}"
end


def share_link(m, b)
  surl = m.get_o2o_url(b)
  if params[:openid] and current_user
    surl += "?openid=#{current_user.get_openid}"
  end
  surl
end


def get_objects(tt, beaconid=nil)
  cond = '1=1'
  cond = "beaconid=#{beaconid}" if beaconid
  obs =  tt.capitalize.constantize.where(cond).order('created_at desc').limit(20)
  obs.map{|ob|[ob.title, ob.id]}
end


end
