# frozen_string_literal: true

class RepositoryCheckMailer < ApplicationMailer
  def report_failed_check
    check = params[:check]
    @user = check.repository.user
    @repository = check.repository
    @subject = t('mailers.check.subject.failed')
    mail(to: @user.email, subject: @subject)
  end
end
