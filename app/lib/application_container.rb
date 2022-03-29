# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :check_repository_service, -> { CheckRepositoryServiceStub }
    register :octokit_client, -> { OctokitClientStub }
  else
    register :check_repository_service, -> { CheckRepositoryService }
    register :octokit_client, -> { Octokit::Client }
  end
end
