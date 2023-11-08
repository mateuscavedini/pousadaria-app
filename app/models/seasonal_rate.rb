class SeasonalRate < ApplicationRecord
  belongs_to :room

  validates :start_date, :finish_date, :rate, presence: true
  validate :dates_overlapping, :dates_are_future, :finish_date_is_later_than_start_date

  private

  def dates_overlapping
    current_range = Range.new(self.start_date, self.finish_date)

    SeasonalRate.all.each do |rate|
      existing_range = Range.new(rate.start_date, rate.finish_date)

      if current_range.overlaps? existing_range
        self.errors.add(:base, 'Não deve haver sobreposição de datas entre Preços Sazonais')
        break
      end
    end
  end

  def dates_are_future
    self.errors.add(:start_date, 'Data Inicial deve ser futura') if self.start_date.present? && self.start_date <= Date.current
    self.errors.add(:finish_date, 'Data Final deve ser futura') if self.finish_date.present? && self.finish_date <= Date.current
  end

  def finish_date_is_later_than_start_date
    if self.start_date.present? && self.finish_date.present?
      self.errors.add(:finish_date, 'Data Final deve ser posterior à Data Inicial') if self.start_date >= self.finish_date
    end
  end
end
