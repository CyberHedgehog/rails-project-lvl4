# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    repo = repositories(:one)
    @repo_commits = JSON.parse(load_fixture('files/commits.json'))
    stub_request(:get, "https://api.github.com/repositories/#{repo.github_id}/commits").to_return(status: 200, body: @repo_commits)
  end

  test 'hook_test' do
    hook_commits = JSON.parse(load_fixture('files/api/commits.json'))

    post api_checks_path hook_commits
    check = Repository::Check.find_by(commit: hook_commits['commits'][0]['id'])
    assert check
    assert_response :success
  end
end
