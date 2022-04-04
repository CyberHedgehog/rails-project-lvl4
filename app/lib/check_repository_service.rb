# frozen_string_literal: true

class CheckRepositoryService
  def initialize
    @tmp_dir = Dir.mktmpdir
    @bash_runner = ApplicationContainer['bash_runner'].new
  end

  def download(url)
    @bash_runner.run("git clone #{url} #{@tmp_dir}")
    @bash_runner.run("git -C #{@tmp_dir} rev-parse HEAD")
  end

  def check(language)
    return check_js if language == 'javascript'
    return check_ruby if language == 'ruby'
  end

  def remove_tmpdir
    @bash_runner.run("rm -rf #{@tmp_dir}")
  end

  private

  def check_js
    result, code = @bash_runner.run("npx eslint #{@tmp_dir} --no-eslintrc -c #{Rails.root.join('.eslintrc.yml')} -f json")
    return ['[]', code] if result.empty?

    parsed_result = JSON.parse(result).map do |item|
      messages = item['messages'].map do |message|
        { rule: message['ruleId'], message: message['message'], line: message['line'], column: message['column'] }
      end
      { file: item['filePath'], messages: messages }
    end
    [JSON.generate(parsed_result), code]
  end

  def check_ruby
    result, code = @bash_runner.run("rubocop #{@tmp_dir} --format json")
    return ['[]', code] if result.empty?

    parsed_result = JSON.parse(result)['files'].map do |item|
      messages = item['offenses'].map do |offense|
        { rule: offense['cop_name'], message: offense['message'], line: offense['location']['line'], column: offense['location']['column'] }
      end
      { file: item['path'], messages: messages }
    end
    [JSON.generate(parsed_result), code]
  end
end
