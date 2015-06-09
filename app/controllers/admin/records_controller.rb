class Admin::RecordsController < Admin::BaseController
  respond_to :html

  def index
    cond = "1=1"
    cond += " and beaconid=#{params[:beaconid]}" if params[:beaconid]
    cond += " and user_id=#{params[:user_id]}" if params[:user_id]
    cond += " and game_id=#{params[:game_id]}" if params[:game_id]
    cond += " and from_user_id=#{params[:from_user_id]}" if params[:from_user_id]
    cond += " and object_id=#{params[:object_id]}" if params[:object_id]
    limit = 20
    limit = params[:limit].to_i if params[:limit]
    @records = Record.where(cond).order('created_at desc').page(params[:page]).per(limit)
  end

end
