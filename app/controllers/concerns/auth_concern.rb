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
end
