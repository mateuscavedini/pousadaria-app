require 'rails_helper'

describe 'Proprietário cadastra um quarto' do
  it 'para uma pousada da qual não é dono' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)
    room_params = { room: { name: 'Primeiro Quarto', description: 'Primeiro quarto da pousada do José', area: 40, max_capacity: 2, daily_rate: 95.99, has_bathroom: true, has_balcony: false, has_air_conditioner: false, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true } }

    login_as maria
    post guesthouse_rooms_path(jose_guesthouse), params: room_params

    expect(response).to redirect_to root_path
  end
end