class Admin::AnswersController < Admin::BaseController

  def new
    @material = ::Material.find params[:material_id]
    @answer = @material.answers.build
    render partial: 'form'
  end

  def create
    answer = Answer.new answer_params
    answer.save
    expire_fragment(answer.viewable)
    redirect_to [:edit,:admin,answer.viewable]
  end

  def edit
    @answer = Answer.find params[:id]
    render partial: 'form'
  end

  def update
    answer = Answer.find params[:id]
    answer.update_attributes answer_params
    expire_fragment(answer.viewable)
    redirect_to [:edit,:admin,answer.viewable]
  end

  def destroy
    answer = Answer.find(params[:id]) 
    expire_fragment(answer.viewable)
    answer.destroy
    render nothing: true
  end

  private
  def answer_params
    params.require(:answer).permit(:title,:group,:viewable_id,:viewable_type,:img, :big_than, :small_than)
  end
end
