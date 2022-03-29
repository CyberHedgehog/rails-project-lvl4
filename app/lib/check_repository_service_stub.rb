# frozen_string_literal: true

class CheckRepositoryServiceStub
  def download(_url)
    ['04a4f4760b7afd29c6bf85bd8f81fc97b17af367']
  end

  def check(_lang)
    data = File.read(Rails.root.join('test/fixtures/files/check_result'))
    status = ProcessStatusStub.new
    [data, status]
  end

  def remove_tmpdir
    ['']
  end
end
