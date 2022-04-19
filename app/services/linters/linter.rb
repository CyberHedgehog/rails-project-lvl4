# frozen_string_literal: true

class Linters::Linter
  def initialize
    @bash_runner = ApplicationContainer['bash_runner'].new
  end

  def run(dir)
    lint_result, code = lint(dir)
    return ['[]', code] if lint_result.empty?

    [parse(lint_result), code]
  end
end
