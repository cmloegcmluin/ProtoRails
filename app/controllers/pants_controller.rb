class PantsController < ControllerBase
  def index
    @pants = Pant.all
    #implicitly renders index!
  end

  def new
  end

  def create
    @pant = Pant.new(params[:pant]) #no pant_params yet; require doesn't exist?
    if @pant.save
      redirect_to "/pants"
    else
      render :new
    end
  end

end
