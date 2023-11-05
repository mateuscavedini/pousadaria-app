class Address < ApplicationRecord
  belongs_to :guesthouse

  validates :street_name, :street_number, :district, :city, :state, :postal_code, presence: true
  validates :postal_code, uniqueness: true
end
