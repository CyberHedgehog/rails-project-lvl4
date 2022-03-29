# frozen_string_literal: true

class UpdateRepositoryDataJob < ApplicationJob
  queue_as :default

  def perform(repository)
    client = ApplicationContainer['octokit_client'].new(access_token: repository.user.token)
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
