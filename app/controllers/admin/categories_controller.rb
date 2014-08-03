class Admin::CategoriesController < Admin::BaseController

  before_action :get_game_types, :only => [:new, :edit]

  def index
    categories = Category.includes(:materials)

    if params[:game_type_id]
      categories = categories.where(:game_type_id => params[:game_type_id].to_i)
    end

    @categories = categories.order("id desc").page(params[:page])
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
    #@category.materials.each do |mate|
    #  expire_fragment(mate)
    #end

    expire_material(@category)

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
    params.require(:category).permit(:name,:meta,:js,:css,:html,:re_js,:re_css,:re_html, :wx_js, :material_type, :game_type_id)
  end

  def expire_material(category)
    materials = category.materials
    materials.each do |m|
      clear_page(m)
    end
  end

  def get_game_types
    @game_types = GameType.all.collect{|gt| [gt.game_type, gt.id] }
  end

end
