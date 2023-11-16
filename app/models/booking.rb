class Booking < ApplicationRecord
  belongs_to :guest
  belongs_to :room

  enum status: { pending: 0, ongoing: 2, finished: 4, canceled: 6 }

  validates :start_date, :finish_date, :guests_number, presence: true
  validates_with DatesAreFutureValidator, FinishDateIsLaterThanStartDateValidator, DatesAreAvailableValidator
  validate :guests_number_respects_room_capacity

  private

  def guests_number_respects_room_capacity
    self.errors.add(:guests_number, 'deve respeitar a capacidade máxima do quarto') if self.guests_number.present? && self.guests_number > self.room.max_capacity
  end
end
