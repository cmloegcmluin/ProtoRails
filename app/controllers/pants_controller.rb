require_relative '../models/pant'

class PantsController < ControllerBase
  def index
    @pants = Pant.all
    render :index
  end
end
