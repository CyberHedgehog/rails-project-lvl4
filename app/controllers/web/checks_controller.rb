# frozen_string_literal: true

class Web::ChecksController < Web::ApplicationController
  def create
    @repo = Repository.find_by(id: params[:repository_id])
    check = @repo.checks.new(commit: '', passed: false)
    authorize check
    if check.save
      CheckRepositoryJob.perform_later(check)
    end
    redirect_to repository_path(@repo), alert: t('repository.create.error.not_created')
  end

  def show
    @check = Repository::Check.find_by(id: params[:id])
    authorize @check.repository
    render 'web/repositories/checks/show'
  end
end
