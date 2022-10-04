class Card < ApplicationRecord
  belongs_to :user

  extend Enumerize

  enumerize :visibility, in: %i[private public]

  validates :name, presence: true
end
