class Admin::GameTypesController < Admin::BaseController

  def index
    @game_types = GameType.all
  end

  def new
    @game_type = GameType.new
  end

  def create
    game_type = GameType.new(game_type_params)
    game_type.save
    redirect_to :back
  end

  def edit
    @game_type = GameType.find(params[:id])
  end

  def update
    game_type = GameType.find(params[:id])
    game_type.update_attributes(game_type_params)
    game_type.save
    redirect_to admin_game_types_path
  end

  private
  def game_type_params
    params.require(:game_type).permit(:game_type)
  end

end