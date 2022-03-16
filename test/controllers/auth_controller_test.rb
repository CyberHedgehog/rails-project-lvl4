# frozen_string_literal: true

require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest
  test 'should sign in' do
    github_user_data = Faker::Omniauth.github
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = nil
    OmniAuth.config.add_mock(:github, github_user_data)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    get callback_auth_path :github
    user = User.find_by(email: github_user_data[:info][:email])
    assert_redirected_to root_path
    assert session[:user_id]
    assert user
  end
end
