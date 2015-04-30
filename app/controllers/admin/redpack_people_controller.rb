class Admin::RedpackPeopleController < Admin::BaseController

  def new
    @redpack = Redpack.find params[:redpack_id] 
    @redpack_person = RedpackPerson.new(:redpack_id => @redpack.id)
    render partial: 'form'
  end

  def create
    @redpack = Redpack.find params[:redpack_id]
    @redpack_person = RedpackPerson.new(redpack_person_params.merge(:redpack_id =>@redpack.id))
    @redpack_person.save
    redirect_to [:edit, :admin, @redpack]
  end

  def destroy
    @redpack = Redpack.find params[:redpack_id]
    redpack_person = RedpackPerson.find params[:id]
    redpack_person.destroy
    redirect_to [:edit, :admin, @redpack]
  end

  def edit
    @redpack = Redpack.find params[:redpack_id]
    @redpack_person = RedpackPerson.find params[:id]
    render partial: 'form'
  end

  def update
    redpack = Redpack.find params[:redpack_id]
    redpack_person = RedpackPerson.find params[:id]
    redpack_person.update_attributes(redpack_person_params)
    redirect_to [:edit, :admin, redpack]
  end

  def redpack_person_params
    params.require(:redpack_person).permit(:name, :time_id, :value_id)
  end

end
