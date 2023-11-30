class Api::V1::RoomsController < Api::V1::ApiController
  def index
    guesthouse = Guesthouse.find(params[:guesthouse_id])

    return render status: 404, json: { message: 'Pousada está inativa.' } if guesthouse.inactive?

    rooms = guesthouse.rooms.active

    render status: 200, json: rooms.as_json(only: [:name, :description, :area, :daily_rate])
  end
end