class ChecksController < ApplicationController
  before_action :set_check, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @checks = Check.all
    respond_with(@checks)
  end

  def show
    respond_with(@check)
  end

  def new
    @check = Check.new
    respond_with(@check)
  end

  def edit
  end

  def create
    @check = Check.new(check_params)
    @check.save
    respond_with(@check)
  end

  def update
    @check.update(check_params)
    respond_with(@check)
  end

  def destroy
    @check.destroy
    respond_with(@check)
  end

  private
    def set_check
      @check = Check.find(params[:id])
    end

    def check_params
      params.require(:check).permit(:beacondid, :user_id, :state, :lng, :lat)
    end
end
