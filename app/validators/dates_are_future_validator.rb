class DatesAreFutureValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:start_date, 'deve ser futura') if record.start_date.present? && record.start_date <= Date.current

    record.errors.add(:finish_date, 'deve ser futura') if record.finish_date.present? && record.finish_date <= Date.current
  end
end