class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit extra fields for sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :bio, :avatar])
    
    # Permit extra fields for account update
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :bio, :avatar])
  end
end
