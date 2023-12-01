require 'rails_helper'

describe 'Proprietário responde avaliação' do
  it 'e deve estar autenticado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), check_in: 1.day.from_now, check_out: 5.days.from_now, room: room, guest: guest, status: :finished)
    review = Review.create!(rating: 4, comment: 'Ótima pousada! Quarto espaçoso e aconchegante.', booking: booking)

    visit new_reply_review_path(review)

    expect(current_path).to eq new_owner_session_path
  end

  it 'a partir do menu' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), check_in: 1.day.from_now, check_out: 5.days.from_now, room: room, guest: guest, status: :finished)
    review = Review.create!(rating: 4, comment: 'Ótima pousada! Quarto espaçoso e aconchegante.', booking: booking)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Avaliações'
    click_on 'Responder'

    expect(page).to have_content 'Responder Avaliação'
    expect(page).to have_content "Reserva #{booking.code}"
    expect(page).to have_content 'Hóspede: Maria dos Santos'
    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Comentário: Ótima pousada! Quarto espaçoso e aconchegante.'
    expect(page).to have_field 'Resposta'
    expect(page).to have_button 'Enviar'
  end
  
  it 'com sucesso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), check_in: 1.day.from_now, check_out: 5.days.from_now, room: room, guest: guest, status: :finished)
    review = Review.create!(rating: 4, comment: 'Ótima pousada! Quarto espaçoso e aconchegante.', booking: booking)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Avaliações'
    click_on 'Responder'
    fill_in 'Resposta', with: 'Agradecemos pela estadia e avaliação!'
    click_on 'Enviar'

    expect(page).to have_content 'Resposta registrada com sucesso.'
    expect(page).to have_content "Reserva #{booking.code}"
    expect(page).to have_content 'Resposta: Agradecemos pela estadia e avaliação!'
  end

  it 'de pousada que não é sua' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, total_price: room.calculate_total_price(1.day.from_now.to_date, 5.days.from_now.to_date), check_in: 1.day.from_now, check_out: 5.days.from_now, room: room, guest: guest, status: :finished)
    jose_review = Review.create!(rating: 4, comment: 'Ótima pousada! Quarto espaçoso e aconchegante.', booking: booking)

    login_as maria, scope: :owner
    visit new_reply_review_path(jose_review)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso.'
  end
end