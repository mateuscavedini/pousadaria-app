class Room < ApplicationRecord
  belongs_to :guesthouse
  has_many :seasonal_rates
  has_many :bookings
  has_many :guests, through: :bookings

  enum status: { active: 0, inactive: 2 }

  validates :name, :description, :area, :max_capacity, :daily_rate, presence: true
end
