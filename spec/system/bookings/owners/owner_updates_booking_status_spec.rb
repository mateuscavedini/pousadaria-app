require 'rails_helper'

describe 'Proprietário altera status de uma reserva' do
  it 'para em andamento (check-in)' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), room: room, guest: guest, status: :pending)

    travel_to 1.day.from_now do
      login_as owner, scope: :owner
      visit root_path
      click_on 'Reservas'
      click_on booking.code
      click_on 'Realizar Check-In'
    end

    expect(page).to have_content 'Check-In realizado com sucesso.'
    expect(page).to have_content 'Status: Em Andamento'
    expect(page).to have_link 'Realizar Check-Out'
    expect(page).not_to have_button 'Cancelar Reserva'
    expect(page).not_to have_button 'Realizar Check-In'
  end

  it 'para cancelado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), room: room, guest: guest, status: :pending)

    travel_to 3.days.from_now do
      login_as owner, scope: :owner
      visit root_path
      click_on 'Reservas'
      click_on booking.code
      click_on 'Cancelar Reserva'
    end

    expect(page).to have_content 'Reserva cancelada com sucesso.'
    expect(page).to have_content 'Status: Cancelado'
    expect(page).not_to have_button 'Cancelar Reserva'
    expect(page).not_to have_button 'Realizar Check-In'
    expect(page).not_to have_link 'Realizar Check-Out'
  end

  it 'para finalizada e vê resumo antes de efetivar' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), room: room, guest: guest, status: :ongoing, check_in: 1.day.from_now)
    check_out_date = 5.days.from_now.at_beginning_of_day + 10.hours + 31.minutes

    travel_to check_out_date do
      login_as owner, scope: :owner
      visit root_path
      click_on 'Reservas Em Andamento'
      click_on booking.code
      click_on 'Realizar Check-Out'
    end

    expect(page).to have_content 'Resumo Check-Out'
    expect(page).to have_content 'Total a Pagar: R$ 600,00'
    expect(page).to have_field 'Forma de Pagamento'
    expect(page).to have_button 'Confirmar Check-Out'
  end

  it 'para finalizada e efetiva alteração' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), room: room, guest: guest, status: :ongoing, check_in: 1.day.from_now)
    check_out_date = 5.days.from_now.at_beginning_of_day + 10.hours + 31.minutes

    travel_to check_out_date do
      login_as owner, scope: :owner
      visit root_path
      click_on 'Reservas Em Andamento'
      click_on booking.code
      click_on 'Realizar Check-Out'
      fill_in 'Forma de Pagamento', with: 'Dinheiro'
      click_on 'Confirmar Check-Out'
    end

    expect(page).to have_content 'Check-Out realizado com sucesso.'
    expect(page).to have_content 'Status: Finalizado'
    expect(page).not_to have_button 'Cancelar Reserva'
    expect(page).not_to have_button 'Realizar Check-In'
    expect(page).not_to have_link 'Realizar Check-Out'
  end
end