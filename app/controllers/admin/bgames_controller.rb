class Admin::BgamesController < Admin::BaseController
  before_action :set_bgame, only: [:show, :edit, :update, :destroy]

  State = [["下线", 0], ["上线", 1]]

  respond_to :html

  def index
    @bgames = Bgame.all
    respond_with(@bgames)
  end

  def show
    respond_with(@bgame)
  end

  def new
    if params[:material_id]
      @game = Material.find params[:material_id]
      @bgame = @game.bgames.new
    else
      @bgame = Bgame.new
    end
    respond_with(@bgame)
  end

  def edit
    if params[:material_id]
      @game = Material.find params[:material_id]
    end
  end

  def create
    @bgame = Bgame.new(bgame_params)
    @bgame.save
    redirect_to [:admin, :bgames]
  end

  def update
    @bgame.update(bgame_params)
    redirect_to [:admin, :bgames]
  end

  def destroy
    @bgame.destroy
    redirect_to [:admin, :bgames]
  end

  private
    def set_bgame
      @bgame = Bgame.find(params[:id])
    end

    def bgame_params
      params.require(:bgame).permit(:beaconid, :game_id, :state, :remark)
    end
end
