# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authorize_user
  def index
    @repositories = current_user.repositories
  end

  def new
    @repository = Repository.new
    github_repositories = client.repos(per_page: 100)
    @repositories = github_repositories.pluck(:full_name, :id)
  end

  def create
    if repository_params[:github_id].nil?
      redirect_to new_repository_path, alert: t('messages.blank_github')
      return
    end

    repository = current_user.repositories.new(github_id: repository_params[:github_id])
    if repository.save
      UpdateRepositoryDataJob.perform_later(repository)
      CreateRepositoryHookJob.perform_later(repository)
      redirect_to repository_path(repository)
    else
      redirect_to repositories_path
    end
  end

  def show
    @repository = Repository.find(params[:id])
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end

  def client
    @client = Octokit::Client.new(access_token: current_user.token, per_page: 100)
  end

  def authorize_user
    authorize :repository
  end
end
