class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!


  protected

  def configure_permitted_parameters
    @keys = [:username, :email, :password]
    devise_parameter_sanitizer.permit(:sign_up, keys: @keys)
    devise_parameter_sanitizer.permit(:account_update, keys: @keys)
  end

  def after_sign_in_path_for(user)
    cookies[:name] = current_user.username
    "/"
  end

  def after_sign_up_path_for(user)
    cookies[:name] = current_user.username
    "/text_adventure_home"
  end

end
