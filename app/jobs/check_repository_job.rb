# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check)
    check.check!
    checker = ApplicationContainer['check_repository_service'].new
    client = Octokit::Client.new
    repo_data = client.repository(check.repository.full_name)
    checker.download(repo_data.git_url)
    check_result = checker.check(check.repository.language)
    check_passed = JSON.parse(check_result).empty?
    check.update(result: check_result, check_passed: check_passed)
    check.finish!
    checker.remove_tmpdir
  end
end
