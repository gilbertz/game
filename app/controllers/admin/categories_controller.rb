class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.order("id desc")
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
    @category.update_attributes category_params
    redirect_to [:edit,:admin,@category]
  end

  def destroy
    @category = Category.find params[:id]
    render nothing: true
  end

  private
  def category_params
    params.require(:category).permit(:name,:meta,:js,:css,:html,:re_js,:re_css,:re_html)
  end
end
