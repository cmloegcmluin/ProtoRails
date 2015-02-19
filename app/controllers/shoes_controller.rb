require_relative 'application_controller.rb'

class ShoesController < ApplicationController
  def new
    @pants = Pant.all
  end

  def create
    #@shoe = Shoe.new(params[:shoe])
    @shoe = Shoe.new(shoe_params)
    @shoe.save
    redirect_to "/pants"
  end

  private

  def shoe_params
    #debugger
    params.require(:shoe).permit(:name, :pant_id)
  end
end
