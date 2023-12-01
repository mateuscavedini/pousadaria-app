class DatesAreFutureValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:start_date, 'deve ser futura') if record.start_date.present? && record.start_date <= Time.zone.now

    record.errors.add(:finish_date, 'deve ser futura') if record.finish_date.present? && record.finish_date <= Time.zone.now
  end
end