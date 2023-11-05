class Room < ApplicationRecord
  belongs_to :guesthouse

  validates :name, :description, :area, :max_capacity, :daily_rate, presence: true
end
