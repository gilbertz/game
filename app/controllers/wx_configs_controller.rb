class WxConfigsController < ApplicationController
  before_action :set_wx_config, only: [:show, :edit, :update, :destroy]

  # GET /wx_configs
  # GET /wx_configs.json
  def index
    @wx_configs = WxConfig.all
  end

  # GET /wx_configs/1
  # GET /wx_configs/1.json
  def show
  end

  # GET /wx_configs/new
  def new
    @wx_config = WxConfig.new
  end

  # GET /wx_configs/1/edit
  def edit
  end

  # POST /wx_configs
  # POST /wx_configs.json
  def create
    @wx_config = WxConfig.new(wx_config_params)

    respond_to do |format|
      if @wx_config.save
        format.html { redirect_to @wx_config, notice: 'Wx config was successfully created.' }
        format.json { render action: 'show', status: :created, location: @wx_config }
      else
        format.html { render action: 'new' }
        format.json { render json: @wx_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wx_configs/1
  # PATCH/PUT /wx_configs/1.json
  def update
    respond_to do |format|
      if @wx_config.update(wx_config_params)
        format.html { redirect_to @wx_config, notice: 'Wx config was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @wx_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wx_configs/1
  # DELETE /wx_configs/1.json
  def destroy
    @wx_config.destroy
    respond_to do |format|
      format.html { redirect_to wx_configs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wx_config
      @wx_config = WxConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wx_config_params
      params.require(:wx_config).permit(:wx_ad, :wx_link, :wx_id, :secret)
    end
end
