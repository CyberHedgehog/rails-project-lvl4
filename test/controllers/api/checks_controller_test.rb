# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repo_commits = JSON.parse(load_fixture('files/commits.json'))
  end

  test 'hook_test' do
    hook_commits = JSON.parse(load_fixture('files/api/commits.json'))

    post api_checks_path hook_commits
    check = Repository::Check.find_by(commit: '')
    assert check.passed
    assert_response :success
  end
end
