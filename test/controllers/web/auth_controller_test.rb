# frozen_string_literal: true

require 'test_helper'

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'should sign in' do
    user = users(:one)
    sign_in(user)
    assert session[:user_id]
    assert_redirected_to root_path
  end
end
