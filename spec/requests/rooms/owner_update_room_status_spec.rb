require 'rails_helper'

describe 'Usuário altera status de um quarto' do
  it 'de uma pousada que não é sua para ativo' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)
    jose_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 10000, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: jose_guesthouse, status: :inactive)

    login_as maria
    post activated_guesthouse_room_path(jose_guesthouse, jose_room)

    expect(response).to redirect_to root_path
  end

  it 'de uma pousada que não é sua para inativo' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)
    jose_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 10000, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: jose_guesthouse, status: :active)

    login_as maria
    post deactivated_guesthouse_room_path(jose_guesthouse, jose_room)

    expect(response).to redirect_to root_path
  end

  it 'que não é de sua pousada para ativo' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    maria_address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    maria_contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    maria_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Maria Brasil LTDA', trading_name: 'Pousada da Maria', registration_number: '42153668000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: maria_address_attributes, contact_attributes: maria_contact_attributes, owner: maria)
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    jose_address_attributes = { street_name: 'Av do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '22020-002' }
    jose_contact_attributes = { phone: '11998444225', email: 'contato@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: jose_address_attributes, contact_attributes: jose_contact_attributes, owner: jose)
    jose_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: jose_guesthouse, status: :inactive)

    login_as maria
    post activated_guesthouse_room_path(maria_guesthouse, jose_room)

    expect(response).to redirect_to root_path
  end

  it 'que não é de sua pousada para inativo' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    maria_address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    maria_contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    maria_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Maria Brasil LTDA', trading_name: 'Pousada da Maria', registration_number: '42153668000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: maria_address_attributes, contact_attributes: maria_contact_attributes, owner: maria)
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    jose_address_attributes = { street_name: 'Av do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '22020-002' }
    jose_contact_attributes = { phone: '11998444225', email: 'contato@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: jose_address_attributes, contact_attributes: jose_contact_attributes, owner: jose)
    jose_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: jose_guesthouse, status: :active)

    login_as maria
    post deactivated_guesthouse_room_path(maria_guesthouse, jose_room)

    expect(response).to redirect_to root_path
  end
end