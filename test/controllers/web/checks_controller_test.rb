# frozen_string_literal: true

require 'test_helper'

class Web::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'shold create check' do
    user = users(:one)
    repository = repositories(:one)
    sign_in(user)
    post repository_checks_path(repository)
    assert_equal repository.checks.last.commit, '04a4f4'
  end

  test 'should show check' do
    sign_in(users(:one))
    repository = repositories(:one)
    check = repository.checks.first
    get repository_check_path(repository.id, check.id)
    assert_response :success
  end
end
