# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    keys = %i[name email password password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
  end
end
