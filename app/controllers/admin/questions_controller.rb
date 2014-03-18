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

  def destroy
    question = Question.find(params[:id])
    material = question.material
    question.destroy
    question.save

    redirect_to edit_admin_material_path(material)
  end

  def edit
    @question = Question.find(params[:id])
    render :partial => "form"
  end

  def update
    question = Question.find(params[:id])
    question.update_attributes(question_params)
    question.save
    redirect_to :back
  end

  private
  def question_params
    params.require(:question).permit(:question_title, :material_id)
  end

end