# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check)
    check.check!
    checker = CheckRepositoryService.new
    repository = check.repository
    rev, = checker.download(repository.clone_url)
    check_result, code = checker.check(repository.language)
    check.update(commit: rev[0..5], result: check_result, passed: code.zero?)
    RepositoryCheckMailer.with(check: check).report_failed_check.deliver_later unless code.zero?
    check.finish!
    checker.remove_tmpdir
  end
end
