class Room < ApplicationRecord
  belongs_to :guesthouse
  has_many :seasonal_rates
  has_many :bookings
  has_many :guests, through: :bookings

  enum status: { active: 0, inactive: 2 }

  validates :name, :description, :area, :max_capacity, :daily_rate, presence: true

  def calculate_total_price(start_date, finish_date)
    stay_range = Range.new(start_date.to_date, finish_date.to_date)
    seasonal_rates = SeasonalRate.active.where(room_id: self.id)

    return stay_range.count * self.daily_rate unless seasonal_rates.present?

    total_price = 0
    regular_days = stay_range.to_a

    stay_range.each do |day|
      seasonal_rates.each do |seasonal_rate|
        seasonal_rate_range = Range.new(seasonal_rate.start_date.to_date, seasonal_rate.finish_date.to_date)

        if seasonal_rate_range.include? day
          total_price += seasonal_rate.rate
          regular_days.delete(day)
        end
      end
    end

    return total_price unless regular_days.present?

    total_price + (regular_days.count * self.daily_rate)
  end
end
