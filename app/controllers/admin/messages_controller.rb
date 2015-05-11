class Admin::MessagesController < Admin::BaseController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @messages = Message.all
    respond_with(@messages)
  end

  def show
    respond_with(@message)
  end

  def new
    @message = Message.new
    respond_with(@message)
  end

  def edit
  end

  def create
    @message = Message.new(message_params)
    @message.save
    redirect_to admin_ibeacons_path
  end

  def update
    @message.update(message_params)
    redirect_to admin_ibeacons_path
  end

  def destroy
    @message.destroy
    redirect_to admin_ibeacons_path
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:beaconid, :content, :start_time, :end_time, :count, :state)
    end
end
