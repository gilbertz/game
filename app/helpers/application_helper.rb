module ApplicationHelper

def material_path(m)
  "/weitest/#{m.url}"
end


def share_link(m, b)
  if m.share_url.blank?
    surl = m.get_o2o_url(b)
  else
    surl = m.share_url
  end
  if m.social_share? and current_user
    surl += "?openid=#{current_user.get_openid}"
  end
  surl
end


def pyq_share_link(m, b)
  if m.pyq_url.blank?
    share_link(m, b)
  else
    m.pyq_url
  end
end

def get_objects(tt, beaconid=nil)
  cond = '1=1'
  cond = "beaconid=#{beaconid}" if beaconid
  obs =  tt.capitalize.constantize.where(cond).order('created_at desc').limit(20)
  [['无', 0]] + obs.map{|ob|[ob.title, ob.id]}
end

def fix_slb(url)
  url = url.gsub('app_game', 'wx.yaoshengyi.com')
  url
end

end
