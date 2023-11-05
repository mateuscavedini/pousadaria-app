class Contact < ApplicationRecord
  belongs_to :guesthouse

  validates :phone, :email, presence: true
end
