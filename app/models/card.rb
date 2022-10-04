class Card < ApplicationRecord
  belongs_to :user

  extend Enumerize

  enumerize :visibility, in: %i[private public], default: :private
  enumerize :word_type, in: %i[noun verb adjective], default: :noun, scope: true

  validates :name, presence: true
  validates :template, presence: true
  validates :visibility, presence: true
  validates :word_type, presence: true
end
