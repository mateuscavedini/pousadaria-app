class Guesthouse < ApplicationRecord
  belongs_to :owner
  has_one :contact
  has_one :address
  has_many :rooms

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :contact

  enum status: {active: 0, inactive: 2}

  validates :corporate_name, :trading_name, :registration_number, :description, :usage_policy, :check_in, :check_out, :payment_methods, presence: true
  validates :registration_number, uniqueness: true
end
