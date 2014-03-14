class Admin::QuestionAnswersController < Admin::BaseController

  def new
    @question = Question.find(params[:question_id])
    @question_answer = @question.question_answers.build

    render :partial => "form"
  end

  def create
    question_answer = QuestionAnswer.new(question_answer_params)
    question_answer.save

    expire_fragment(question_answer.question.material)
    redirect_to [:edit,:admin,question_answer.question.material]
  end

  def destroy
    question_answer = QuestionAnswer.find(params[:id])
    question_answer.destroy

    expire_fragment(question_answer.question.material)
    redirect_to [:edit,:admin,question_answer.question.material]
  end

  def edit
    @question_answer = QuestionAnswer.find(params[:id])
    @question = @question_answer.question

    expire_fragment(@question.material)
    render :partial => "form"
  end

  def update
    question_answer = QuestionAnswer.find params[:id]
    question_answer.update_attributes question_answer_params

    expire_fragment(question_answer.question.material)
    redirect_to [:edit,:admin,question_answer.question.material]
  end


  private
  def question_answer_params
    params.require(:question_answer).permit(:answer, :answer_score, :question_id)
  end

end