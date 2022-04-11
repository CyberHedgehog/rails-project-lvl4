# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check)
    checker = CheckRepositoryService.new
    checker.check(check)
  end
end
