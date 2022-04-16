# frozen_string_literal: true

class Linters::Javascript < Linters::Linter
  private

  def lint(dir)
    @bash_runner.run("npx eslint #{dir} --no-eslintrc -c #{Rails.root.join('.eslintrc.yml')} -f json")
  end

  def parse(lint_data)
    result = JSON.parse(lint_data).filter { |item| item['messages'].any? }.map do |item|
      messages = item['messages'].map do |message|
        { rule: message['ruleId'], message: message['message'], line: message['line'], column: message['column'] }
      end
      file = item['filePath'].split('/').drop(3).join('/')
      { file: file, messages: messages }
    end
    JSON.generate(result)
  end
end
