# frozen_string_literal: true

class GithubClientStub
  def initialize(params)
    @access_token = params[:access_token]
  end

  def repos
    repo_data = File.read(Rails.root.join('test/fixtures/files/repo.json'))
    [repo_data]
  end

  def create_hook
  end

  def repository
  end

  
end
