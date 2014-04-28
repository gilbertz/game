class Api::FeedbacksController < Api::ApiController

  def index
    @feedback = Feedback.new
    render :layout => false
  end

  def create
    @feedback = Feedback.new feedback_params
    @feedback.save

    unless params[:back].blank?
      redirect_to :back, notice: "反馈成功! 感谢您的支持!"
      return
    end

  end
  #############################################################################
  private
  def feedback_params
    params.require(:feedback).permit(:content, :username)
  end

end