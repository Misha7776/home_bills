class Property < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user
  has_one_attached :photo

  validates :name, presence: true
  validates_uniqueness_of :name
end
