class Admin::CardOptionsController < Admin::BaseController
  before_action :set_card_option, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @card_options = CardOption.all
    respond_with(@card_options)
  end

  def show
    respond_with(@card_option)
  end

  def new
    @card = Card.find params[:card_id]
    @card_option = CardOption.new(:card_id => @card.id)
    render partial: 'form'
  end

  def edit
    @card = Card.find params[:card_id]
    @card_option = CardOption.find(params[:id])
    render partial: 'form'
  end

  def create
    @card = Card.find params[:card_id]
    @card_option = @card.card_options.new( {:card_id => @card.id}.merge(card_option_params) )
    @card_option.save
    redirect_to [:edit, :admin, @card]
 end

  def update
    @card = Card.find params[:card_id]
    @card_option.update(card_option_params)
    redirect_to [:edit, :admin, @card]
  end

  def destroy
    @card = Card.find params[:card_id]
    @card_option.destroy
    redirect_to [:edit, :admin, @card]
  end

  private
    def set_card_option
      @card_option = CardOption.find(params[:id])
    end

    def card_option_params
      params.require(:card_option).permit(:value, :store, :title, :img, :wx_cardid, :desc, :probability)
    end
end
