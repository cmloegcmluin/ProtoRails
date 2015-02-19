require_relative 'application_controller.rb'

class UsersController < ApplicationController
  def show
    #@user = User.find(params["id"])
    @user = User.find(params[:id])
  end

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!(@user)
      redirect_to "/posts"
    else
      #flash.now[:notices] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
