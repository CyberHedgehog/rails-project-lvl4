# frozen_string_literal: true

require 'test_helper'

class Web::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'shold create check' do
    user = users(:one)
    repository = repositories(:one)
    sign_in(user)
    post repository_checks_path(repository)
    assert_equal repository.checks.last.commit, ''
  end

  test 'should show check' do
    sign_in(users(:one))
    repository = repositories(:one)
    check = repository.checks.first
    get repository_check_path(repository.id, check.id)
    assert_response :success
  end

  test 'shold not create check if not owner' do
    user = users(:one)
    repository = repositories(:two)
    sign_in(user)
    post repository_checks_path(repository)
    assert_redirected_to root_path
  end

  test 'should not show check if not owner' do
    sign_in(users(:one))
    repository = repositories(:two)
    check = repository.checks.first
    get repository_check_path(repository.id, check.id)
    assert_redirected_to root_path
  end
end
