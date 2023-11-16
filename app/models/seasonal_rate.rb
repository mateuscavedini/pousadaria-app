class SeasonalRate < ApplicationRecord
  belongs_to :room

  enum status: { active: 0, inactive: 2 }

  validates :start_date, :finish_date, :rate, presence: true
  validates_with DatesAreFutureValidator, FinishDateIsLaterThanStartDateValidator, DatesAreAvailableValidator
end
