class Guesthouse < ApplicationRecord
  belongs_to :owner
  has_one :contact
  has_one :address
  has_many :rooms
  has_many :bookings, through: :rooms
  has_many :reviews, through: :bookings

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact

  enum status: {active: 0, inactive: 2}

  validates :corporate_name, :trading_name, :registration_number, :description, :usage_policy, :check_in, :check_out, :payment_methods, presence: true
  validates :registration_number, uniqueness: true

  def average_rating
    self.reviews.average(:rating).round(2) if self.reviews.any?
  end
end
