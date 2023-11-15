require 'rails_helper'

describe 'Proprietário edita uma pousada' do
  it 'mas não é sua' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas e Hotéis Brasil LTDA', trading_name: 'Pousada do José', registration_number: '98765432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)

    login_as maria, scope: :owner
    patch guesthouse_path(jose_guesthouse), params: { guesthouse: { trading_name: 'Novo Nome Pousada' } }

    expect(response).to redirect_to root_path
  end
end