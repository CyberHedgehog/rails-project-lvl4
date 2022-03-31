# frozen_string_literal: true

class OctokitClientStub
  def initialize(params)
    @access_token = params[:access_token]
  end

  def repos
    repos_data = File.read(Rails.root.join('test/fixtures/files/repo.json'))
    [JSON.parse(repos_data)]
  end

  def create_hook(_repo, _name, _config)
    {
      type: 'Repository',
      id: 1,
      active: true
    }
  end

  def repository(_github_id)
    repo_data = File.read(Rails.root.join('test/fixtures/files/repo.json'))
    JSON.parse(repo_data)
  end
end
