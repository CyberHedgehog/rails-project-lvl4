# frozen_string_literal: true

class GithubClient
  def client
    Octokit::Client.new(access_token: current_user.token, per_page: 100)
  end
end
