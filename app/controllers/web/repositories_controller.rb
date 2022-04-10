# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action authorize: :repository, except: :show
  def index
    @repositories = current_user.repositories.page params[:page]
  end

  def new
    @repository = Repository.new
    @repositories = Rails.cache.fetch("#{current_user.id}/repositories", expires_in: 1.hour) do
      repos = client.repos
      available_languages = Repository.language.values
      repos.filter { |repo| available_languages.include? repo[:language]&.downcase }.pluck(:full_name, :id)
    end
  end

  def create
    if repository_params[:github_id].nil?
      redirect_to new_repository_path, alert: t('repository.create.error.blank_github')
      return
    end

    repository = current_user.repositories.new(github_id: repository_params[:github_id])
    if repository.save
      UpdateRepositoryDataJob.perform_later(repository)
      CreateRepositoryHookJob.perform_later(repository, api_checks_url)
      redirect_to repository_path(repository)
    else
      redirect_to repositories_path, alert: t('repository.create.error.not_created')
    end
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end

  def client
    @client = ApplicationContainer['octokit_client'].new(access_token: current_user.token, per_page: 100)
  end
end
