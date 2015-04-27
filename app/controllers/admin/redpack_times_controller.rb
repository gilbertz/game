class Admin::RedpackTimesController < Admin::BaseController

  def new
    @redpack = Redpack.find params[:redpack_id] 
    @redpack_time = RedpackTime.new(:redpack_id => @redpack.id)
    render partial: 'form'
  end

  def create
    @redpack = Redpack.find params[:redpack_id]
    @redpack_time = RedpackTime.new(redpack_time_params.merge(:redpack_id =>@redpack.id))
    @redpack_time.save
    redirect_to [:edit, :admin, @redpack]
  end

  def destroy
    @redpack = Redpack.find params[:redpack_id]
    redpack_time = RedpackTime.find params[:id]
    redpack_time.destroy
    redirect_to [:edit, :admin, @redpack]
  end

  def edit
    @redpack = Redpack.find params[:redpack_id]
    @redpack_time = RedpackTime.find params[:id]
    render partial: 'form'
  end

  def update
    redpack = Redpack.find params[:redpack_id]
    redpack_time = RedpackTime.find params[:id]
    redpack_time.update_attributes(redpack_time_params)
    redirect_to [:edit, :admin, redpack]
  end

  def redpack_time_params
    params.require(:redpack_time).permit(:start_time, :end_time, :frequency, :min, :max, :store, :state, :probability)
  end

end
