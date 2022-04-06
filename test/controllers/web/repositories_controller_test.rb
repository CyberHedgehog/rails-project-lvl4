# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repo = JSON.parse(load_fixture('files/repo.json'))
  end

  test 'should get index' do
    sign_in(users(:one))
    get repositories_path
    assert_response :success
  end

  test 'should show' do
    user = users(:one)
    sign_in(user)
    get repository_path(user.repositories.first)
    assert_response :success
  end

  test 'should not show if not owner' do
    user = users(:one)
    second_user = users(:two)
    sign_in(user)
    get repository_path(second_user.repositories.first)
    assert_redirected_to :root
  end

  test 'should get new' do
    sign_in(users(:one))
    get new_repository_path
    assert_response :success
  end

  test 'should create' do
    sign_in(users(:one))
    post repositories_path, params: { repository: { github_id: @repo['id'] } }
    new_repository = Repository.find_by(github_id: @repo['id'])
    assert new_repository
  end
end
