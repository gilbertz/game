class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.includes(:materials).order("id desc").page(params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    category = Category.new category_params
    category.save
    redirect_to [:admin, :categories]
  end

  def clone
    category = ::Category.find params[:id] 
    ::Category.create category.attributes.except!("created_at", "id")
    redirect_to [:admin,:categories]
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    @category.materials.each do |mate|
      expire_fragment(mate)
    end
    @category.update_attributes category_params
    redirect_to [:edit,:admin,@category]
  end

  def destroy
    @category = Category.find params[:id]
    arg = @category.destroy ? 'ok' : 'err'
    render json: {msg: arg}
  end

  private
  def category_params
    params.require(:category).permit(:name,:meta,:js,:css,:html,:re_js,:re_css,:re_html)
  end
end
