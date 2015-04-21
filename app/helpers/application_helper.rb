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

end
