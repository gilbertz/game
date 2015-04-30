class Admin::ScoresController < Admin::BaseController
  before_action :set_score, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    cond = "1=1"
    cond += " and beaconid=#{params[:beaconid]}" if params[:beaconid]
    cond += " and user_id=#{params[:user_id]}" if params[:user_id]
    cond += " and game_id=#{params[:game_id]}" if params[:game_id]
    @scores = Score.where(cond).order('created_at desc').page(params[:page]) 
    respond_with(@scores)
  end

  def show
    respond_with(@score)
  end

  def new
    @score = Score.new
    respond_with(@score)
  end

  def edit
  end

  def create
    @score = Score.new(score_params)
    @score.save
    redirect_to [:admin, :scores]
  end

  def update
    @score.update(score_params)
    redirect_to [:admin, :scores]
  end

  def destroy
    @score.destroy
    redirect_to [:admin, :scores]
  end

  private
    def set_score
      @score = Score.find(params[:id])
    end

    def score_params
      params.require(:score).permit(:user_id, :beaconid, :value, :from_user_id, :remark)
    end
end
