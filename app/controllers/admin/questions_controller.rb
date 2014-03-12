class Admin::QuestionsController < Admin::BaseController

  def new
    @material = Material.find params[:material_id]
    @question = @material.questions.build
    render :partial => "form"
  end

  def create
    question = Question.new(question_params)
    question.save

    expire_fragment(question.material)
    redirect_to [:edit,:admin,question.material]
  end

  private
  def question_params
    params.require(:question).permit(:question_title, :material_id)
  end

end