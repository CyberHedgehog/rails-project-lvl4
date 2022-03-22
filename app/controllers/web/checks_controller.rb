# frozen_string_literal: true

class Web::ChecksController < Web::ApplicationController
  def create
    repo = Repository.find_by(id: params[:repository_id])
    check = repo.checks.new(commit: '')
    if check.save
      CheckRepositoryJob.perform_later(check)
    end
    redirect_to repository_path(repo)
  end

  def show
    @check = Repository::Check.find_by(id: params[:id])
    render 'web/repositories/checks/show'
  end

  private

  def client
    @client = Octokit::Client.new(access_token: current_user.token)
  end
end
