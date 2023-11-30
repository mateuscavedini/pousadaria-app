class Api::V1::GuesthousesController < Api::V1::ApiController
  def index
    term = "%#{params[:query]}%"
    guesthouses = Guesthouse.active.where('trading_name LIKE :term', term: term)

    render status: 200, json: guesthouses.as_json(only: [:id, :trading_name], include: { address: { only: [:city] } })
  end

  def show
    guesthouse = Guesthouse.find(params[:id])
    
    return render status: 404, json: { message: 'Pousada está inativa.' } if guesthouse.inactive?

    render status: 200, json: generate_json(guesthouse)
  end

  private

  def generate_json(guesthouse)
    json = guesthouse.as_json(only: [:id, :trading_name, :description, :allow_pets, :usage_policy, :check_in, :check_out, :payment_methods], include: { address: { only: [:street_name, :street_number, :complement, :district, :city, :state, :postal_code] }, contact: { only: [:phone, :email] } }, methods: :average_rating)

    json['check_in'] = guesthouse.check_in.strftime('%H:%M')
    json['check_out'] = guesthouse.check_out.strftime('%H:%M')

    json['average_rating'] = '' unless guesthouse.average_rating.present?
    json['address']['complement'] = '' if json['address']['complement'].nil?

    json
  end
end