# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repo = JSON.parse(load_fixture('files/repo.json'))
    stub_request(:get, 'https://api.github.com/user/repos').to_return(status: 200, body: [@repo])
    stub_request(:get, @repo['url']).to_return(status: 200, body: load_fixture('files/repo.json'))
  end
  test 'should get index' do
    sign_in(users(:one))
    get repositories_path
    assert_response :success
  end

  test 'should get new' do
    sign_in(users(:one))
    get new_repository_path
    assert_response :success
  end

  test 'should create' do
    sign_in(users(:one))
    post repositories_path, params: { repository: { full_name: @repo['full_name'] } }
  end
end
