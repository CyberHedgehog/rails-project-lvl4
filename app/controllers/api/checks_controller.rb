# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    repository = Repository.find_by(github_id: params['repository']['id'])
    if repository.nil?
      render json: { error: t('api.check.repository_not_found') }
      return
    end

    check = repository.checks.new(commit: '', passed: false)
    if check.save
      CheckRepositoryJob.perform_later(check)
      pp '!!!!!Check', check
      render json: check.to_json
    else
      render json: { error: t('api.check.create.error') }
    end
  end
end
