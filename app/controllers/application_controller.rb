class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection #this module is added because it contains the definition of verfiy_authenticity_token  
  protect_from_forgery prepend: true
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?
  def devise_controller?
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end
end
