# frozen_string_literal: true

class CheckRepositoryService
  def initialize
    @tmp_dir = Dir.mktmpdir
    @bash_runner = ApplicationContainer['bash_runner'].new
  end

  def check(check)
    check.check!
    repository = check.repository
    rev, = download(repository.clone_url)
    if repository.language.nil?
      check.update(passed: false)
      check.finish!
      return
    end

    linter = "Linters::#{repository.language.capitalize}".constantize.new
    result, code = linter.run(@tmp_dir)
    check.update(commit: rev[0..5], result: result, passed: code.zero?)
    RepositoryCheckMailer.with(check: check).report_failed_check.deliver_later unless code.zero?
    check.finish!
    @bash_runner.run("rm -rf #{@tmp_dir}")
  end

  private

  def download(url)
    @bash_runner.run("git clone #{url} #{@tmp_dir}")
    @bash_runner.run("git -C #{@tmp_dir} rev-parse HEAD")
  end
end
