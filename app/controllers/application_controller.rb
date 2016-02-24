class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :config_devise_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: t(:no_permission)
  end

  def config_devise_permitted_parameters
    registration_params = [:name, :email, :avatar, :role, :charwork_id, :password, :password_confirmation]

    if params[:action] == "update"
      devise_parameter_sanitizer.for :account_update do |u|
        u.permit registration_params << :current_password
      end
    elsif params[:action] == "create"
      devise_parameter_sanitizer.for :sign_up do |u|
        u.permit registration_params
      end
    end
  end
end
