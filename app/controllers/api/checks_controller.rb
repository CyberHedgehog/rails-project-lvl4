# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    render json: { error: 'Bad request data' } if params['commits'].nil?

    repository = Repository.find_by(github_id: params['repository']['id'])
    check = repository.checks.create(commit: params['commits'][0]['id'])
    CheckRepositoryJob.perform_later(check)
    render json: check.to_json
  end
end
