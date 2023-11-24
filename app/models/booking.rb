class Booking < ApplicationRecord
  belongs_to :guest, optional: true
  belongs_to :room
  has_one :review

  enum status: { pending: 0, ongoing: 2, finished: 4, canceled: 6 }

  before_validation :generate_code, on: :create

  validates :start_date, :finish_date, :guests_number, :code, presence: true
  validates_with DatesAreFutureValidator, FinishDateIsLaterThanStartDateValidator, DatesAreAvailableValidator, on: :create
  validate :guests_number_respects_room_capacity

  private

  def guests_number_respects_room_capacity
    self.errors.add(:guests_number, 'deve respeitar a capacidade máxima do quarto') if self.guests_number.present? && self.guests_number > self.room.max_capacity
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
end
