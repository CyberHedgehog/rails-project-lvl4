# frozen_string_literal: true

class CheckRepositoryService
  def initialize
    @tmp_dir = Dir.mktmpdir
  end

  def run(command)
    Open3.popen3(command) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }
  end

  def download(url)
    run("git clone #{url} #{@tmp_dir}")
  end

  def check(language)
    return check_js if language == 'JavaScript'
    return check_ruby if language == 'Ruby'
  end

  def remove_tmpdir
    run("rm -rf #{@tmp_dir}")
  end

  private

  def check_js
    result, _code = run("npx eslint #{@tmp_dir} --no-eslintrc -c #{Rails.root.join('.eslintrc.yml')} -f json")
    return '[]' if result.empty?

    parsed_result = JSON.parse(result).map do |item|
      messages = item['messages'].map do |message|
        { rule: message['ruleId'], message: message['message'], line: message['line'], column: message['column'] }
      end
      { file: item['filePath'], messages: messages }
    end
    JSON.generate(parsed_result)
  end

  def check_ruby
    result, _code = run("rubocop #{@tmp_dir} --format json")
    parsed_result = JSON.parse(result)['files'].map do |item|
      messages = item['offenses'].map do |offense|
        { rule: offense['cop_name'], message: offense['message'], line: offense['location']['line'], column: offense['location']['column'] }
      end
      { file: item['path'], messages: messages }
    end
    JSON.generate(parsed_result)
  end
end
