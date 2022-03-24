# frozen_string_literal: true

class CheckRepositoryServiceStub
  def download(_url)
    [Faker::Crypto.sha1]
  end

  def check
    File.read("#{File.dirname(__FILE__)}/fixtures/files/check_result")
  end

  def remove_tmpdir
    ['']
  end
end
