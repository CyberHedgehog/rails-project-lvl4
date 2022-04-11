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
    result, code = lint(repository.language)
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

  def lint(language)
    return lint_js if language == 'javascript'
    return lint_ruby if language == 'ruby'
  end

  def lint_js
    result, code = @bash_runner.run("npx eslint #{@tmp_dir} --no-eslintrc -c #{Rails.root.join('.eslintrc.yml')} -f json")
    return ['[]', code] if result.empty?

    parsed_result = JSON.parse(result).filter { |item| item['messages'].any? }.map do |item|
      messages = item['messages'].map do |message|
        { rule: message['ruleId'], message: message['message'], line: message['line'], column: message['column'] }
      end
      file = item['filePath'].split('/').drop(3).join('/')
      { file: file, messages: messages }
    end
    [JSON.generate(parsed_result), code]
  end

  def lint_ruby
    result, code = @bash_runner.run("rubocop #{@tmp_dir} --format json")
    return ['[]', code] if result.empty?

    parsed_result = JSON.parse(result)['files'].filter { |file| file['offenses'].any? }.map do |item|
      messages = item['offenses'].map do |offense|
        { rule: offense['cop_name'], message: offense['message'], line: offense['location']['line'], column: offense['location']['column'] }
      end
      file = item['path'].split('/').drop(3).join('/')
      { file: file, messages: messages }
    end
    [JSON.generate(parsed_result), code]
  end
end
