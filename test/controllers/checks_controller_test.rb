# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    repo = repositories(:one)
    @commits = JSON.parse(load_fixture('files/commits.json'))
    stub_request(:get, "https://api.github.com/repositories/#{repo.github_id}/commits").to_return(status: 200, body: @commits)
  end

  test 'shold create check' do
    user = users(:one)
    repository = user.repositories.first

    sign_in(user)
    post repository_checks_path(repository)
    assert_equal repository.checks.last.commit, @commits[0]['sha']
  end

  test 'should show check' do
    sign_in(users(:one))
    repository = repositories(:one)
    check = repository.checks.first
    get repository_check_path(repository.id, check.id)
    assert_response :success
  end
end
