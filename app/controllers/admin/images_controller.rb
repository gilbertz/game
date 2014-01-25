class Admin::ImagesController < Admin::BaseController

  def new
    material = Material.find params[:material_id]
    @image = material.images.build(state: params[:state])
    render partial: 'form'
  end

  def create
    image = ::Image.new image_params
    image.save
    material = image.viewable
    expire_fragment(material)
    redirect_to [:edit,:admin,material]
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
