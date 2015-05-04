class Admin::MerchantsController < Admin::BaseController
  before_action :set_merchant, only: [:show, :edit, :update, :destroy]

   State = [["下线", 0], ["上线", 1], ["社区", 2]]

  respond_to :html

  def index
    @merchants = Merchant.all
    #respond_with(@merchants)
    #redirect_to admin_merchants_path
  end

  def show
    respond_with(@merchant)
  end

  def new
    @merchant = Merchant.new
    respond_with(@merchant)
  end

  def edit
  end

  def create
    @merchant = Merchant.new(merchant_params)
    @merchant.save
    #respond_with(@merchant)
    redirect_to admin_merchants_path
  end

  def update
    @merchant.update(merchant_params)
    #respond_with(@merchant)
    redirect_to admin_merchants_path
  end

  def destroy
    @merchant.destroy
    #respond_with(@merchant)
    redirect_to admin_merchants_path
  end

  def clone
    merchant = Merchant.find params[:id]
    merchant.cloning(true)
    redirect_to [:admin,:merchants]
  end
  

  private
    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    def merchant_params
      params.require(:merchant).permit(:name, :mch_id, :wxappid, :key, :certificate, :rsa, :rsa_key, :state, :money, :user_id, :beaconid)
    end
end
