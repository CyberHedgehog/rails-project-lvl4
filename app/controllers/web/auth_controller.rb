# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    auth_info = auth[:info]
    user = User.find_or_initialize_by(email: auth_info[:email].downcase)
    user.name = auth_info[:name]
    user.nickname = auth_info[:nickname]
    user.image_url = auth_info[:image]
    user.token = auth[:credentials][:token]
    if user.save
      sign_in user
      redirect_to root_path, notice: t('auth.success')
    else
      redirect_to root_path, alert: t('auth.error')
    end
  end

  protected

  def auth
    request.env['omniauth.auth']
  end
end
