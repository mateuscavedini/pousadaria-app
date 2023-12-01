require 'rails_helper'

describe 'Proprietário vê todas as avaliações de sua pousada' do
  it 'a partir do menu' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    first_guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    second_guest = Guest.create!(first_name: 'José', last_name: 'Alves', social_number: '99988877765', email: 'jose@email.com', password: 'senha123')
    third_guest = Guest.create!(first_name: 'Luis', last_name: 'Rodrigues', social_number: '99911188827', email: 'luisr@email.com', password: 'senha123')
    first_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), check_in: 1.day.from_now, check_out: 5.days.from_now, room: room, guest: first_guest, status: :finished)
    second_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), check_in: 1.day.from_now, check_out: 5.days.from_now, room: room, guest: second_guest, status: :finished)
    third_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), check_in: 1.day.from_now, check_out: 5.days.from_now, room: room, guest: third_guest, status: :finished)
    Review.create!(rating: 4, comment: 'Ótima pousada! Quarto espaçoso e aconchegante.', booking: first_booking)
    Review.create!(rating: 4, comment: 'Recomendo!', booking: second_booking)
    Review.create!(rating: 3, comment: 'Uma boa pousada, mas com preços elevados.', booking: third_booking)

    login_as owner, scope: :owner
    visit root_path
    within '#header-links' do
      click_on 'Avaliações'
    end

    expect(page).to have_content 'Minhas Avaliações'
    expect(page).to have_content "Reserva #{first_booking.code}"
    expect(page).to have_content 'Hóspede: Maria dos Santos'
    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Comentário: Ótima pousada! Quarto espaçoso e aconchegante.'
    expect(page).to have_content "Reserva #{second_booking.code}"
    expect(page).to have_content 'Hóspede: José Alves'
    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Comentário: Recomendo!'
    expect(page).to have_content "Reserva #{third_booking.code}"
    expect(page).to have_content 'Hóspede: Luis Rodrigues'
    expect(page).to have_content 'Nota: 3'
    expect(page).to have_content 'Comentário: Uma boa pousada, mas com preços elevados.'
    expect(page).not_to have_content 'Pousada Teste - Primeiro Quarto'
  end

  it 'e não existem avaliações' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, total_price: room.calculate_total_price(1.day.from_now, 5.days.from_now), room: room, guest: guest, status: :finished)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Avaliações'

    expect(page).to have_content 'Não existem avaliações a serem exibidas.'
  end
end