class Room < ApplicationRecord
  belongs_to :guesthouse

  enum status: { active: 0, inactive: 2 }

  validates :name, :description, :area, :max_capacity, :daily_rate, presence: true
end
