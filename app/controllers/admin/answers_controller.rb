class Admin::AnswersController < Admin::BaseController

  def new
    @material = ::Material.find params[:material_id]
    @answer = @material.answers.build
    render partial: 'form'
  end

  def create
    answer = Answer.new answer_params
    answer.save
    redirect_to [:edit,:admin,answer.viewable]
  end

  def edit
    @answer = Answer.find params[:id]
    render partial: 'form'
  end

  def update
    @answer = Answer.find params[:id]
    @answer.update_attributes answer_params
    redirect_to [:edit,:admin,@answer.viewable]
  end

  def destroy
    Answer.find(params[:id]).destroy
    render nothing: true
  end
  private
  def answer_params
    params.require(:answer).permit(:title,:material_id,:img)
  end
end
