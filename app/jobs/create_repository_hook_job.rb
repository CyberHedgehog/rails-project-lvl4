# frozen_string_literal: true

class CreateRepositoryHookJob < ApplicationJob
  queue_as :default

  include Rails.application.routes.url_helpers

  def perform(repository)
    client = ApplicationContainer['octokit_client'].new(access_token: repository.user.token)
    client.create_hook(repository.github_id, 'web', { url: api_checks_url, content_type: 'json' })
  end
end
