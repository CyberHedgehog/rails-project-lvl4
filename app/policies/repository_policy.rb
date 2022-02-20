# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def new?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end
end