class ApplicationController < ControllerBase
  #protect_from_forgery with: :exception

  #helper_method :current_user, :logged_in?

  def login!(user)
    session[:token] = user.reset_session_token!
    session.store_session(@res)
  end

  def logout!
    current_user.try(:reset_session_token!)
    session[:token] = nil
  end

  def current_user
    @current_user ||= User.where("session_token" => session[:token]).first
  end

  def logged_in?
    !!current_user
  end

  def require_logged_in!
    redirect_to "/session/new" unless logged_in?
  end
end
