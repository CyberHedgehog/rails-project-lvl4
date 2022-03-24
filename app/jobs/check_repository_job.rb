# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check)
    check.check!
    checker = ApplicationContainer['check_repository_service'].new
    client = Octokit::Client.new
    # repo_data = client.repository(check.repository.full_name)
    commit_name = client.commits(check.repository.full_name).first[:sha]
    checker.download("https://github.com/#{check.repository.full_name}.git")
    check_result, code = checker.check(check.repository.language)
    check.update(commit: commit_name, result: check_result, passed: code.success?)
    RepositoryCheckMailer.with(check: check).report_failed_check.deliver_later unless code.success?
    check.finish!
    checker.remove_tmpdir
  end
end
