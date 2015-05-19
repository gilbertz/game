class Admin::CodeBlocksController < Admin::BaseController
  before_action :set_code_block, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @code_blocks = CodeBlock.all
    respond_with(@code_blocks)
  end

  def show
    respond_with(@code_block)
  end

  def new
    @category = Category.find params[:category_id]
    @code_block = CodeBlock.new(:category_id => @category.id)
    render partial: 'form'
  end

  def edit
    @category = Category.find params[:category_id] if params[:category_id]
    @code_block = CodeBlock.find(params[:id])
    render partial: 'form'
  end

  def create
    @category = Category.find params[:category_id]
    @code_block = @category.code_blocks.new( {:category_id => @category.id}.merge(code_block_params) )
    @code_block.save
    redirect_to [:edit, :admin, @category]
 end

  def update
    @category = Category.find params[:category_id] if params[:category_id]
    @code_block.update(code_block_params)
    redirect_to [:edit, :admin, @category]
  end

  def destroy
    @category = Category.find params[:category_id]
    @code_block.destroy
    redirect_to [:edit, :admin, @category]
  end

  private
    def set_code_block
      @code_block = CodeBlock.find(params[:id])
    end

    def code_block_params
      params.require(:code_block).permit(:category_id, :code, :state)
    end
end
