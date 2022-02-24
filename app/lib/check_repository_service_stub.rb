# frozen_string_literal: true

class CheckRepositoryServiceStub
  def download(_url)
    ['']
  end

  def check
    ['[{}]']
  end

  def remove_tmpdir
    ['']
  end
end
