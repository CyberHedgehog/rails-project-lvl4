# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :check_repository_service, -> { CheckRepositoryServiceStub }
  else
    register :check_repository_service, -> { CheckRepositoryService }
  end
end
