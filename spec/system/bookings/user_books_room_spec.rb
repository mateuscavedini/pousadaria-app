require 'rails_helper'

describe 'Usuário realiza reserva de quarto' do
  it 'e precisa estar autenticado para confirmar' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'
    fill_in 'Data Inicial', with: 1.day.from_now
    fill_in 'Data Final', with: 5.days.from_now
    fill_in 'Quantidade de Hóspedes', with: '1'
    click_on 'Enviar'
    click_on 'Confirmar Reserva'

    expect(current_path).to eq new_guest_session_path
  end

  it 'a partir da tela inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'

    expect(page).to have_content 'Realizar Reserva'
    expect(page).to have_content 'Detalhes do Quarto'
    expect(page).to have_content 'Nome: Primeiro Quarto'
    expect(page).to have_content 'Descrição: Primeiro quarto a ser cadastrado'
    expect(page).to have_content 'Área: 50m²'
    expect(page).to have_content 'Capacidade Máxima: 2 pessoa(s)'
    expect(page).to have_content 'Diária: R$ 100,00'
    expect(page).to have_content 'Possui Banheiro? Sim'
    expect(page).to have_content 'Possui Varanda? Não'
    expect(page).to have_content 'Possui Ar Condicionado? Sim'
    expect(page).to have_content 'Possui TV? Sim'
    expect(page).to have_content 'Possui Guarda-roupas? Sim'
    expect(page).to have_content 'Possui Cofre? Sim'
    expect(page).to have_content 'É acessível para PCDs? Sim'
    expect(page).to have_content 'Informações da Reserva'
    expect(page).to have_field 'Data Inicial'
    expect(page).to have_field 'Data Final'
    expect(page).to have_field 'Quantidade de Hóspedes'
  end

  it 'e vê resumo da reserva' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'
    fill_in 'Data Inicial', with: 1.day.from_now
    fill_in 'Data Final', with: 5.days.from_now
    fill_in 'Quantidade de Hóspedes', with: '1'
    click_on 'Enviar'

    expect(page).to have_content 'Resumo da Reserva'
    expect(page).to have_content 'Total a Pagar: R$ 500,00'
    expect(page).to have_button 'Confirmar Reserva'
  end

  it 'com dados inválidos' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'
    fill_in 'Data Inicial', with: ''
    fill_in 'Data Final', with: ''
    fill_in 'Quantidade de Hóspedes', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível fazer a pré-reserva.'
    expect(page).to have_content 'Erros:'
    expect(page).to have_content 'Data Inicial não pode ficar em branco'
    expect(page).to have_content 'Data Final não pode ficar em branco'
    expect(page).to have_content 'Quantidade de Hóspedes não pode ficar em branco'
  end

  it 'mas quarto já está reservado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    maria = Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    Booking.create!(start_date: 5.days.from_now, finish_date: 10.days.from_now, guests_number: 2, room: room, guest: maria)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'
    fill_in 'Data Inicial', with: 4.days.from_now
    fill_in 'Data Final', with: 6.days.from_now
    fill_in 'Quantidade de Hóspedes', with: 1
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível fazer a pré-reserva.'
    expect(page).to have_content 'Já existe uma reserva no período especificado'
  end

  it 'com datas passadas' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'
    fill_in 'Data Inicial', with: 2.days.ago
    fill_in 'Data Final', with: 1.day.ago
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível fazer a pré-reserva.'
    expect(page).to have_content 'Data Inicial deve ser futura'
    expect(page).to have_content 'Data Final deve ser futura'
  end

  it 'com data final anterior à data inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'
    fill_in 'Data Inicial', with: 2.days.from_now
    fill_in 'Data Final', with: 1.day.from_now
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível fazer a pré-reserva.'
    expect(page).to have_content 'Data Final deve ser posterior à Data Inicial'
  end

  it 'com número de hóspedes acima do limite do quarto' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Reserva Prévia'
    fill_in 'Quantidade de Hóspedes', with: 3
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível fazer a pré-reserva.'
    expect(page).to have_content 'Quantidade de Hóspedes deve respeitar a capacidade máxima do quarto'
  end
end