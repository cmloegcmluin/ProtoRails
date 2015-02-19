require_relative 'application_controller.rb'

class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_credentials(
      params["user"]["email"],
      params["user"]["password"]
      # params[:user][:email],
      # params[:user][:password]
    )
    if @user
      login!(@user)
      debugger
      redirect_to "/users/#{@user.id}"
    else
      #flash.now[:notices] = ["Invalid credentials."]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to "/session/new"
  end
end
