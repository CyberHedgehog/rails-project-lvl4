# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in(@user)
  end

  test 'should get index' do
    get repositories_path
    assert_response :success
  end

  test 'should show' do
    get repository_path(@user.repositories.first)
    assert_response :success
  end

  test 'should not show if not owner' do
    second_user = users(:two)
    get repository_path(second_user.repositories.first)
    assert_redirected_to :root
  end

  test 'should get new' do
    get new_repository_path
    assert_response :success
  end

  test 'should create' do
    @repo = JSON.parse(load_fixture('files/repo.json'))
    post repositories_path, params: { repository: { github_id: @repo['id'] } }
    new_repository = Repository.find_by(github_id: @repo['id'])
    assert_redirected_to repository_path(new_repository)
    assert new_repository.language, @repo['language']
  end
end
