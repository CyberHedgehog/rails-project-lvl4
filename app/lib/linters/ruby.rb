# frozen_string_literal: true

class Linters::Ruby < Linters::Linter
  private

  def lint(dir)
    @bash_runner.run("rubocop #{dir} --format json")
  end

  def parse(lint_data)
    result = JSON.parse(lint_data)['files'].filter { |file| file['offenses'].any? }.map do |item|
      messages = item['offenses'].map do |offense|
        { rule: offense['cop_name'], message: offense['message'], line: offense['location']['line'], column: offense['location']['column'] }
      end
      file = item['path'].split('/').drop(3).join('/')
      { file: file, messages: messages }
    end
    JSON.generate(result)
  end
end
