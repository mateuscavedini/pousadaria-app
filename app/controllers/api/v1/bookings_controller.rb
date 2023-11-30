class Api::V1::BookingsController < Api::V1::ApiController
  def validate
    room = Room.find(params[:room_id])

    return render status: 404, json: { message: 'Pousada está inativa.' } if room.guesthouse.inactive?
    return render status: 404, json: { message: 'Quarto está inativo.' } if room.inactive?

    booking = room.bookings.build(booking_params)

    if booking.valid?
      booking.total_price = room.calculate_total_price(booking.start_date, booking.finish_date)
  
      render status: 200, json: booking.as_json(only: :total_price)
    else
      status = 
        if booking.errors.include? :base
          409
        else
          400
        end

      render status: status, json: { message: 'Parâmetros inválidos.', errors: booking.errors.full_messages }
    end
  end

  private

  def booking_params
    params.permit(:start_date, :finish_date, :guests_number)
  end
end