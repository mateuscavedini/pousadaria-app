class FinishDateIsLaterThanStartDateValidator < ActiveModel::Validator
  def validate(record)
    if record.start_date.present? && record.finish_date.present?
      record.errors.add(:finish_date, 'deve ser posterior à Data Inicial') if record.start_date >= record.finish_date
    end
  end
end