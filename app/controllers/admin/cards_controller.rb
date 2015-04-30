class Admin::CardsController < Admin::BaseController

  before_action :set_card, only: [:show, :edit, :update, :destroy]

  State = [["下线", 0], ["上线", 1]]

  respond_to :html

  def index
    @cards = Card.all
    respond_with(@cards)
  end

  def show
    redirect_to [:admin,:cards]
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = Card.new(card_params)
    @card.save
    redirect_to [:admin,:cards]
  end

  def update
    @card.update(card_params)
    redirect_to [:admin,:cards]
  end

  def destroy
    @card.destroy
    redirect_to [:admin,:cards]
  end

  def clone
    card = Card.find params[:id]
    card.cloning(true)
    redirect_to [:admin,:cards]
  end


  private
    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:beaconid, :shop_id, :state, :appid, :cardid, :title, :sub_title, :desc, :store, :tid, :start_date, :end_date)
    end
end
