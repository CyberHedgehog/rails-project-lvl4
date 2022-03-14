# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authorize_user
  def index
    @repositories = current_user.repositories
  end

  def new
    @repository = Repository.new
    @repositories = client.repos.pluck(:full_name)
  end

  def create
    if repository_params[:full_name].empty?
      redirect_to new_repository_path, alert: t('messages.blank_github')
      return
    end
    repo_data = client.repository(repository_params[:full_name])
    repository = Repository.new(
      {
        github_id: repo_data['id'],
        name: repo_data['name'],
        full_name: repo_data['full_name'],
        language: repo_data['language'],
        user_id: current_user.id
      }
    )
    if repository.save
      client.create_hook(repository.full_name, 'web', { url: api_checks_url, content_type: 'json' })
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
    params.require(:repository).permit(:full_name)
  end

  def client
    @client = Octokit::Client.new(access_token: current_user.token)
  end

  def authorize_user
    authorize :repository
  end
end
