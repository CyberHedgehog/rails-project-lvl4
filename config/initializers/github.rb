# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_APP_SECRET'], scope: 'user:email'
end
