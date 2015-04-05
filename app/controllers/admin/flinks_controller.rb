class FlinksController < ApplicationController
  before_action :set_flink, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @flinks = Flink.all
    respond_with(@flinks)
  end

  def show
    respond_with(@flink)
  end

  def new
    @flink = Flink.new
    respond_with(@flink)
  end

  def edit
  end

  def create
    @flink = Flink.new(flink_params)
    @flink.save
    respond_with(@flink)
  end

  def update
    @flink.update(flink_params)
    respond_with(@flink)
  end

  def destroy
    @flink.destroy
    respond_with(@flink)
  end

  private
    def set_flink
      @flink = Flink.find(params[:id])
    end

    def flink_params
      params.require(:flink).permit(:beaconid, :wxid, :wxurl, :state)
    end
end
