require_relative 'application_controller.rb'

class PantsController < ApplicationController
  def index
    @pants = Pant.all
    #implicitly renders index!
  end

  def new
  end

  def create
    #@pant = Pant.new(params[:pant]) #no pant_params yet; require doesn't exist?
    @pant = Pant.new(pant_params)
    if @pant.save
      redirect_to "/pants"
    else
      render :new
    end
  end

  def show
    @pant = Pant.find(params[:id])
  end

  private

  def pant_params
    params.require(:pant).permit(:name)
  end

end
