# Controller for applicaiton helpers
class ApplicationController < ActionController::Base
  # include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery(
    with: :null_session,
    if: proc { |c| c.request.format == 'application/json' }
  )

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :picture]
  end
end
