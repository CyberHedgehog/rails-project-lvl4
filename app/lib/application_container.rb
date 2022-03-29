# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :octokit_client, -> { OctokitClientStub }
    register :bash_runner, -> { BashRunnerStub }
  else
    register :octokit_client, -> { Octokit::Client }
    register :bash_runner, -> { BashRunner }
  end
end
