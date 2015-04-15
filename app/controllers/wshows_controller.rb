class WshowsController < ApplicationController
  def show
    @wshow = Wshow.find params[:id]
    # puts Beaconid.find_by_beaconid(params[:beaconid])
    id = Ibeacon.find_by(:url=>params[:beaconid]).id
    @rp = Redpack.find_by(beaconid: id).weixin_post.to_i/100
    render layout: false
  end

  def custom
     @wshow = Wshow.find params[:id]
     render layout: false 
  end

  def draft
    #@user = User.find_by_token prarams[:token]
    @user = User.find 1
    k = "kk_#{@user.id}"
    @content = $redis.get k
    render layout: false
  end
end
