# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include AuthConcern
  include Pundit

  helper_method :current_user, :signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :redirect_unauthorized_user

  private

  def redirect_unauthorized_user
    flash.alert = t 'messages.not_authorized'
    redirect_to request.referer || root_path
  end
end
