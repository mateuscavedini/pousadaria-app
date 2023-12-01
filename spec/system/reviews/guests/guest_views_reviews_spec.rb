require 'rails_helper'

describe 'Hóspede vê todas as suas avaliações' do
  it 'e respectivas respostas do proprietário a partir do menu' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    first_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    second_room = Room.create!(name: 'Segundo Quarto', description: 'Segundo quarto a ser cadastrado', area: 30, max_capacity: 2, daily_rate: 50, has_bathroom: true, has_balcony: false, has_air_conditioner: false, has_tv: true, has_wardrobe: false, has_safe: false, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    first_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, total_price: first_room.calculate_total_price(1.day.from_now, 5.days.from_now), room: first_room, guest: guest, status: :finished)
    second_booking = Booking.create!(start_date: 6.days.from_now, finish_date: 10.days.from_now, guests_number: 2, total_price: second_room.calculate_total_price(6.days.from_now, 10.days.from_now), room: second_room, guest: guest, status: :finished)
    first_review = Review.create!(rating: 5, comment: 'Ótima pousada e quarto! Recomendo!', reply: 'Agradecemos a avaliação!', booking: first_booking)
    second_review = Review.create!(rating: 3, comment: 'Ótima pousada mas há quartos melhores.', booking: second_booking)

    login_as guest, scope: :guest
    visit root_path
    within '#header-links' do
      click_on 'Minhas Avaliações'
    end

    expect(page).to have_content "Reserva #{first_booking.code}"
    expect(page).to have_content 'Pousada Teste - Primeiro Quarto'
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Ótima pousada e quarto! Recomendo!'
    expect(page).to have_content 'Resposta: Agradecemos a avaliação!'
    expect(page).to have_content 'Pousada Teste - Segundo Quarto'
    expect(page).to have_content 'Nota: 3'
    expect(page).to have_content 'Comentário: Ótima pousada mas há quartos melhores.'
    expect(page).not_to have_content 'Hóspede: Maria dos Santos'
  end
end