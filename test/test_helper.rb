# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  setup do
    queue_adapter.perform_enqueued_jobs = true
    queue_adapter.perform_enqueued_at_jobs = true
  end
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def load_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end

  def sign_in(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = nil
    OmniAuth.config.add_mock(
      :github,
      {
        provider: 'github',
        uid: Faker::Internet.uuid,
        info: {
          email: user[:email],
          name: user[:name],
          nickname: user[:nickname]
        },
        credentials: { token: Faker::Internet.uuid }
      }
    )
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]

    get callback_auth_path(:github)
  end

  def sign_out
    delete session_path(session.id)
  end

  # Add more helper methods to be used by all tests here...
end
