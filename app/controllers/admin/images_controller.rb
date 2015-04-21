class Admin::ImagesController < Admin::BaseController
  def index
    cond = "1=1"
    @images = Image.where(cond).order('id desc').page(params[:page])
  end

  def new
    if params[:material_id]
      material = Material.find params[:material_id]
      @image = material.images.build(state: params[:state])
    else
      @image = Image.new
    end
    render partial: 'form'
  end

  def create
    if params[:images]
      params[:images].each do |img|
        Image.build(1, nil, nil, img)
      end
      redirect_to [:admin, :images]
    else
      image = ::Image.new image_params 
      image.save
      if image.viewable
        material = image.viewable
        expire_fragment(material)
        redirect_to [:edit,:admin,material]
      else
        redirect_to [:admin, :images]
      end
    end
  end

  def edit
    @image = ::Image.find params[:id]
    render partial: 'form'
  end

  def update
    image = ::Image.find params[:id]
    material = image.viewable
    expire_fragment(material)
    image.update_attributes image_params
    redirect_to [:edit,:admin,material]
  end

  def destroy
    image = ::Image.find params[:id]
    expire_fragment(image.viewable)
    image.destroy
    render nothing: true
  end
  private
  def image_params
    params.require(:image).permit(:title,:viewable_id,:viewable_type,:body,:state)
  end
end
