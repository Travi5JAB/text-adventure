class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    @keys = %i[
      :username
      :email
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: @keys)
    devise_parameter_sanitizer.permit(:account_update, keys: @keys)
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email)
    end
  end

end
