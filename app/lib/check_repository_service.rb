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

  def check
    run("npx eslint #{@tmp_dir} --no-eslintrc -c #{Rails.root.join('.eslintrc.yml')} -f json")
  end

  def remove_tmpdir
    run("rm -rf #{@tmp_dir}")
  end
end
