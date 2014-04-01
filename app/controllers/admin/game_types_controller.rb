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

  private
  def game_type_params
    params.require(:game_type).permit(:game_type)
  end

end