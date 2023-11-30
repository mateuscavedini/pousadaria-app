class Api::V1::GuesthousesController < Api::V1::ApiController
  def index
    term = "%#{params[:query]}%"
    guesthouses = Guesthouse.active.where('trading_name LIKE :term', term: term)

    render status: 200, json: guesthouses.as_json(only: [:id, :trading_name], include: { address: { only: [:city] } })
  end
end