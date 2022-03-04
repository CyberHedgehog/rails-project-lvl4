# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    return if headers['x-github-event'] == 'ping'

    repository = Repository.find_by(full_name: params['repository']['full_name'])
  end
end
