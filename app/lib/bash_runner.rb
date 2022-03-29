# frozen_string_literal: true

class BashRunner
  def run(command)
    result, status = Open3.popen3(command) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }
    [result, status.exitstatus]
  end
end
