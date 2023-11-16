class DatesAreAvailableValidator < ActiveModel::Validator
  def validate(record)
    current_range = Range.new(record.start_date, record.finish_date)

    existing_records =
      case record
      when SeasonalRate then SeasonalRate.where(room_id: record.room_id)
      when Booking then Booking.pending.or(Booking.ongoing).where(room_id: record.room_id)
      end

    existing_records.each do |existing_record|
      return if record.id == existing_record.id

      existing_range = Range.new(existing_record.start_date, existing_record.finish_date)

      if current_range.overlaps? existing_range
        record.errors.add(:base, 'Não deve haver sobreposição de datas entre Preços Sazonais') if record.is_a? SeasonalRate
        
        record.errors.add(:base, 'Já existe uma reserva no período especificado') if record.is_a? Booking

        break
      end
    end
  end
end