require 'rails_helper'

describe 'Proprietário cadastra preço sazonal' do
  it 'para quarto que não é de sua pousada' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)
    jose_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: jose_guesthouse)
    seasonal_rate_params = { seasonal_rate: { start_date: 10.days.from_now, finish_date: 20.days.from_now, rate: 114.99} }

    login_as maria, scope: :owner
    post room_seasonal_rates_path(jose_room), params: seasonal_rate_params

    expect(response).to redirect_to root_path
  end
end