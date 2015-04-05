class Admin::CardsController < Admin::BaseController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

   State = [["下线", 0], ["上线", 1]]

  respond_to :html

  def index
    @cards = Card.all
    respond_with(@cards)
  end

  def show
    respond_with(@card)
  end

  def new
    @card = Card.new
    respond_with(@card)
  end

  def edit
  end

  def create
    @card = Card.new(card_params)
    @card.save
    respond_with(@card)
  end

  def update
    @card.update(card_params)
    respond_with(@card)
  end

  def destroy
    @card.destroy
    respond_with(@card)
  end

  private
    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:beaconid, :shop_id, :state, :appid, :cardid, :title, :sub_title, :desc, :store, :tid, :start_date, :end_date)
    end
end
