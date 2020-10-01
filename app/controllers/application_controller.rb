class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  after_action :track_action

  # after sign in or sign up redirect to map page
      def after_sign_in_path_for(user)
         "/profile/#{current_user.id}"
      end

      def after_sign_up_path_for(user)
         "/profile/#{current_user.id}"
      end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email)
    end
  end

  private
  def track_action
    ahoy.track "Ran action", request.path_parameters
  end

end
