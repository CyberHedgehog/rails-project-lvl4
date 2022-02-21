# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  aasm column: 'state' do
    state :not_checked, initial: true
    state :checking
    state :finished

    event :check do
      transitions from: :not_checked, to: :checking
    end

    event :finish do
      transitions from: :checking, to: :finished
    end
  end

  belongs_to :repository
end
