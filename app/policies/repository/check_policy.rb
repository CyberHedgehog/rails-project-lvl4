# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    user.present? && user == record.repository.user
  end

  def create?
    user.present? && user == record.repository.user
  end
end
