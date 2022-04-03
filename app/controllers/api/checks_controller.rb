# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    repository = Repository.find_by(full_name: params['repository']['full_name'])
    if repository.nil?
      pp 'repository not found', repository
      render json: { error: t('api.check.repository_not_found') }
      return
    end

    check = repository.checks.new(commit: '', passed: false)
    if check.save
      pp 'check before job', check
      CheckRepositoryJob.perform_later(check)
      pp 'check after job', check
      render json: check.to_json
    else
      pp 'not created'
      render json: { error: t('api.check.create.error') }
    end
  end
end
