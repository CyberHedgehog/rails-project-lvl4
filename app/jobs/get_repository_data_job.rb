# frozen_string_literal: true

class GetRepositoryDataJob < ApplicationJob
  queue_as :default

  def perform(repository)
    client = Octokit::Client.new(access_token: repository.user.token)
    repo_data = client.repository(repository.github_id)
    repository.update(
      {
        clone_url: repo_data['clone_url'],
        name: repo_data['name'],
        full_name: repo_data['full_name'],
        language: repo_data['language']
      }
    )
  end
end
