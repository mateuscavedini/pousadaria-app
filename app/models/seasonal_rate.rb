class SeasonalRate < ApplicationRecord
  belongs_to :room

  validates :start_date, :finish_date, :rate, presence: true
end
