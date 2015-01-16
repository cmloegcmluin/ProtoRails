class ShoesController < ControllerBase
  def new
    @pants = Pant.all
  end

  def create
    @shoe = Shoe.new(params[:shoe])
    @shoe.save
    redirect_to "/pants"
  end
end
