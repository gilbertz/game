class Admin::WeixinsController < Admin::BaseController
  before_action :set_weixin, only: [:show, :edit, :update, :destroy]

  # GET /weixins
  # GET /weixins.json
  def index
    @weixins = Weixin.all
  end

  # GET /weixins/1
  # GET /weixins/1.json
  def show
  end

  # GET /weixins/new
  def new
    @weixin = Weixin.new
  end

  # GET /weixins/1/edit
  def edit
  end

  # POST /weixins
  # POST /weixins.json
  def create
    @weixin = Weixin.new(weixin_params)

    respond_to do |format|
      if @weixin.save
        format.html { redirect_to [:admin, @weixin], notice: 'Weixin was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /weixins/1
  # PATCH/PUT /weixins/1.json
  def update
    respond_to do |format|
      if @weixin.update(weixin_params)
        format.html { redirect_to [:edit, :admin, @weixin], notice: 'Weixin was successfully updated.' }
      else
        format.html { render [:edit, :admin, @weixin] }
      end
    end
  end

  # DELETE /weixins/1
  # DELETE /weixins/1.json
  def destroy
    @weixin.destroy
    respond_to do |format|
      format.html { redirect_to weixins_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weixin
      @weixin = Weixin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def weixin_params
      params.require(:weixin).permit(:wxid, :active, :tid)
    end
end
