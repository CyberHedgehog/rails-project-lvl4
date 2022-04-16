# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!

  def create
    @repo = Repository.find_by(id: params[:repository_id])
    check = @repo.checks.new
    authorize check
    if check.save
      CheckRepositoryJob.perform_later(check)
      redirect_to repository_check_path(@repo, check), notice: t('check.create.success')
    else
      redirect_to repository_path(@repo), alert: t('check.create.error.not_created')
    end
  end

  def show
    @check = Repository::Check.find_by(id: params[:id])
    authorize @check
  end
end
