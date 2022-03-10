# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy
  enumerize :language, in: %i[JavaScript Ruby]
  validates :language, presence: true
  validates :full_name, presence: true
end
