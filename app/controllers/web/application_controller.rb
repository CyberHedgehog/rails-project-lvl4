# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include Auth

  helper_method :current_user
end
