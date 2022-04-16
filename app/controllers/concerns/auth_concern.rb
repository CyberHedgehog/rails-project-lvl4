# frozen_string_literal: true

module AuthConcern
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    reset_session
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def authenticate_user!
    return if signed_in?

    flash.alert = t 'messages.not_logged_in'
    redirect_to root_path
  end
end
