require 'rails_helper'

describe 'Hóspede vê todas suas reservas' do
  it 'e deve estar autenticado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    
    within '#header-links' do
      expect(page).not_to have_link 'Minhas Reservas'
    end
  end

  it 'com sucesso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    first_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    second_room = Room.create!(name: 'Segundo Quarto', description: 'Segundo quarto a ser cadastrado', area: 30, max_capacity: 1, daily_rate: 50, has_bathroom: true, has_balcony: false, has_air_conditioner: false, has_tv: true, has_wardrobe: false, has_safe: false, is_accessible: true, guesthouse: guesthouse, status: :active)
    maria = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    jose = Guest.create!(first_name: 'José', last_name: 'Alves', social_number: '99988877765', email: 'jose@email.com', password: 'senha123')
    first_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: first_room.calculate_total_price(1.day.from_now, 5.days.from_now), room: first_room, guest: maria)
    second_booking = Booking.create!(start_date: 6.days.from_now, finish_date: 10.days.from_now, guests_number: 2, total_price: first_room.calculate_total_price(6.days.from_now, 10.days.from_now), room: first_room, guest: jose)
    third_booking = Booking.create!(start_date: 11.day.from_now, finish_date: 15.days.from_now, guests_number: 1, total_price: second_room.calculate_total_price(11.day.from_now, 15.days.from_now), room: second_room, guest: maria)

    login_as maria, scope: :guest
    visit root_path
    within '#header-links' do
      click_on 'Minhas Reservas'
    end

    expect(page).to have_content first_booking.code
    expect(page).to have_content 'Pousada Teste'
    expect(page).to have_content 'Primeiro Quarto'
    expect(page).to have_content I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content I18n.localize(5.days.from_now.to_date)
    expect(page).to have_content '2'
    expect(page).to have_content third_booking.code
    expect(page).to have_content 'Pousada Teste'
    expect(page).to have_content 'Segundo Quarto'
    expect(page).to have_content I18n.localize(11.day.from_now.to_date)
    expect(page).to have_content I18n.localize(15.days.from_now.to_date)
    expect(page).to have_content '1'
    expect(page).to have_content 'Pendente'
    expect(page).not_to have_content second_booking.code
    expect(page).not_to have_content I18n.localize(6.day.from_now.to_date)
    expect(page).not_to have_content I18n.localize(10.days.from_now.to_date)
  end

  it 'e não existem reservas a serem mostradas' do
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

    login_as guest, scope: :guest
    visit my_bookings_path

    expect(page).to have_content 'Você ainda não tem nenhuma reserva.'
  end
end