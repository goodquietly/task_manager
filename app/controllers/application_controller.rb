class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def after_sign_out_path_for(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:new_user_session_path) ? context.new_user_session_path : '/users/sign_in'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name surname])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name surname])
  end

  private

  def record_not_found
    return user_not_authorized unless current_user.present?

    redirect_to root_path, alert: "The #{controller_path} with the given ID does not exist! Choose another."
  end

  def user_not_authorized
    flash[:alert] = 'You are not allowed to perform this action.'

    if request.referrer.present?
      redirect_to(request.referrer)
    elsif current_user.present?
      redirect_to(root_path)
    else
      redirect_to(new_user_session_path)
    end
  end
end
