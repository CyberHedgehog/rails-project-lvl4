# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'shold create check' do
    repository = repositories(:one)
    sign_in(@user)
    post repository_checks_path(repository)
    new_check = repository.checks.last
    assert_equal new_check.commit, ''
    assert_redirected_to repository_check_path(repository, new_check)
  end

  test 'should show check' do
    sign_in(@user)
    repository = repositories(:one)
    check = repository.checks.first
    get repository_check_path(repository.id, check.id)
    assert_response :success
  end

  test 'shold not create check if not owner' do
    repository = repositories(:two)
    sign_in(@user)
    post repository_checks_path(repository)
    assert_redirected_to root_path
  end

  test 'should not show check if not owner' do
    sign_in(@user)
    repository = repositories(:two)
    check = repository.checks.first
    get repository_check_path(repository.id, check.id)
    assert_redirected_to root_path
  end
end
