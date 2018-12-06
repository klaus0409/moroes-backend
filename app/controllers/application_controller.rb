class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  layout :app_layout

  def after_sign_out_path_for(resource)
    new_user_session_path
  end


  def app_layout
    if user_signed_in?
      'application'
    else
      'unsigned'
    end
  end
end
