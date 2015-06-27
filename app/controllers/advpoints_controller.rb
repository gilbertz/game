class AdvpointsController < ApplicationController
  before_action :set_advpoint, only: [:show, :edit, :update, :destroy]

  respond_to :html

  Advtype = [["购物广场", 0], ["网吧", 1],["户外广告屏",2],["停车场",3],["公交巴士",4]]

  def index
    @advpoints = Advpoint.all
    respond_with(@advpoints)
  end

  def show
    respond_with(@advpoint)
  end

  def new
    @advpoint = Advpoint.new
    respond_with(@advpoint)
  end

  def edit
  end

  def create
    @advpoint = Advpoint.new(advpoint_params)
    @advpoint.save
    respond_with(@advpoint)
  end

  def update
    @advpoint.update(advpoint_params)
    respond_with(@advpoint)
  end

  def destroy
    @advpoint.destroy
    respond_with(@advpoint)
  end

  private
    def set_advpoint
      @advpoint = Advpoint.find(params[:id])
    end

    def advpoint_params
      params.require(:advpoint).permit(:company, :province, :city, :address, :advtype, :mark,:trans_desc,:facility_desc,:people_flow, :party_id)
    end
end
