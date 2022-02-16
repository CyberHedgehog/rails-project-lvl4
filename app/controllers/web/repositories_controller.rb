# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  def index
    @repositories = current_user.repositories
  end

  def new
    @repository = Repository.new
    @repositories = client.repos.pluck(:full_name)
  end

  def create
    repo_data = client.repository(repository_params[:full_name])
    repository = Repository.new(
      {
        full_name: repo_data.full_name,
        name: repo_data.name,
        language: repo_data.language,
        user_id: current_user.id
      }
    )
    if repository.save
      redirect_to repository_path(repository)
    else
      redirect_to repositories_path
    end
  end

  def show
    @repository = Repository.find(params[:id])
  end

  protected

  def repository_params
    params.require(:repository).permit(:full_name)
  end

  def client
    @client = Octokit::Client.new(access_token: current_user.token)
  end
end
