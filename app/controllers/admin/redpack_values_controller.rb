class Admin::RedpackValuesController < Admin::BaseController

  def new
    @redpack = Redpack.find params[:redpack_id] 
    @redpack_value = RedpackValue.new(:redpack_id => @redpack.id)
    render partial: 'form'
  end

  def create
    @redpack = Redpack.find params[:redpack_id]
    @redpack_value = RedpackValue.new(redpack_value_params.merge(:redpack_id =>@redpack.id))
    @redpack_value.save
    redirect_to [:edit, :admin, @redpack]
  end

  def destroy
    @redpack = Redpack.find params[:redpack_id]
    redpack_value = RedpackValue.find params[:id]
    redpack_value.destroy
    redirect_to [:edit, :admin, @redpack]
  end

  def edit
    @redpack = Redpack.find params[:redpack_id]
    @redpack_value = RedpackValue.find params[:id]
    render partial: 'form'
  end

  def update
    redpack = Redpack.find params[:redpack_id]
    redpack_value = RedpackValue.find params[:id]
    redpack_value.update_attributes(redpack_value_params)
    redirect_to [:edit, :admin, redpack]
  end

  def redpack_value_params
    params.require(:redpack_value).permit(:money, :num)
  end

end
