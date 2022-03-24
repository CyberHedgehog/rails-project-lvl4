# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check)
    check.check!
    checker = ApplicationContainer['check_repository_service'].new
    repository = check.repository
    rev, = checker.download(repository.clone_url)
    check_result, code = checker.check(repository.language)
    check.update(commit: rev[0..5], result: check_result, passed: code.success?)
    RepositoryCheckMailer.with(check: check).report_failed_check.deliver_later unless code.success?
    check.finish!
    checker.remove_tmpdir
  end
end
