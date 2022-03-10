# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'admin@gihub-quality.com'
  layout 'mailer'
end
