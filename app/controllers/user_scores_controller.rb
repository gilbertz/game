class UserScoresController < ApplicationController
  before_action :set_user_score, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @user_scores = UserScore.all
    respond_with(@user_scores)
  end

  def show
    respond_with(@user_score)
  end

  def new
    @user_score = UserScore.new
    respond_with(@user_score)
  end

  def edit
  end

  def create
    @user_score = UserScore.new(user_score_params)
    @user_score.save
    respond_with(@user_score)
  end

  def update
    @user_score.update(user_score_params)
    respond_with(@user_score)
  end

  def destroy
    @user_score.destroy
    respond_with(@user_score)
  end

  private
    def set_user_score
      @user_score = UserScore.find(params[:id])
    end

    def user_score_params
      params.require(:user_score).permit(:user_id, :beaconid, :total_score, :state)
    end
end
