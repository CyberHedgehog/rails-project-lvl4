# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    repo = repositories(:one)
    check = JSON.parse(load_fixture('files/commits.json'))
    stub_request(:get, "https://api.github.com/repos/#{repo.full_name}/commits").to_return(status: 200, body: check)
  end

  test 'shold create test' do
    user = users(:one)
    repository = user.repositories.first

    sign_in(user)
    post repository_checks_path(repository)
    debugger
    assert_equal repository.checks.last.result, load_fixture('files/check_result')
  end
end