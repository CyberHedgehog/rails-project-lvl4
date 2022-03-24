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

  test 'should get new' do
    stub_request(:get, 'https://api.github.com/user/repos?per_page=100').to_return(status: 200, body: [@repo])

    sign_in(users(:one))
    get new_repository_path
    assert_response :success
  end

  test 'should create' do
    stub_request(:get, @repo['url']).to_return(status: 200, body: load_fixture('files/repo.json'))

    sign_in(users(:one))
    post repositories_path, params: { repository: { github_id: @repo['id'] } }
    new_repository = Repository.find_by(full_name: @repo['full_name'])
    assert new_repository
  end
end
