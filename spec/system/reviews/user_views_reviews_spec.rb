require 'rails_helper'

describe 'Usuário vê avaliações de uma pousada' do
  it 'a partir da página inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    first_room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    second_room = Room.create!(name: 'Segundo Quarto', description: 'Primeiro quarto a ser cadastrado', area: 25, max_capacity: 1, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    maria = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    jose = Guest.create!(first_name: 'José', last_name: 'Alves', social_number: '99988877765', email: 'jose@email.com', password: 'senha123')
    ana = Guest.create!(first_name: 'Ana', last_name: 'Silva', social_number: '99911188827', email: 'ana@email.com', password: 'senha123')
    lucas = Guest.create!(first_name: 'Lucas', last_name: 'Ferreira', social_number: '11199922283', email: 'lucas@email.com', password: 'senha123')
    maria_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, total_price: first_room.calculate_total_price(1.day.from_now, 5.days.from_now), room: first_room, guest: maria, status: :finished)
    jose_booking = Booking.create!(start_date: 6.days.from_now, finish_date: 10.days.from_now, guests_number: 1, total_price: first_room.calculate_total_price(6.days.from_now, 10.days.from_now), room: first_room, guest: jose, status: :finished)
    ana_booking = Booking.create!(start_date: 11.days.from_now, finish_date: 15.days.from_now, guests_number: 1, total_price: first_room.calculate_total_price(11.days.from_now, 15.days.from_now), room: first_room, guest: ana, status: :finished)
    lucas_booking = Booking.create!(start_date: 16.days.from_now, finish_date: 20.days.from_now, guests_number: 1, total_price: second_room.calculate_total_price(16.days.from_now, 20.days.from_now), room: second_room, guest: lucas, status: :finished)
    Review.create!(rating: 5, comment: 'Ótima pousada!', booking: maria_booking)
    Review.create!(rating: 3, comment: 'Boa pousada. Preços não muito atrativos.', booking: jose_booking)
    Review.create!(rating: 4, comment: 'Recomendo! Fui muito bem atendida!', booking: ana_booking)
    Review.create!(rating: 1, comment: 'Não recomendo! Péssimo atendimento!', reply: 'Boa tarde, Lucas! Entramos em contato para entender melhor o que ocorreu. Aguardamos seu retorno.', booking: lucas_booking)

    visit guesthouse_path(guesthouse)
    within '#recent-reviews' do
      click_on 'Todas Avaliações'
    end

    expect(page).to have_content 'Avaliações - Pousada Teste'
    expect(page).to have_content 'Lucas Ferreira'
    expect(page).to have_content 'Quarto: Segundo Quarto'
    expect(page).to have_content 'Nota: 1'
    expect(page).to have_content 'Comentário: Não recomendo! Péssimo atendimento!'
    expect(page).to have_content 'Ana Silva'
    expect(page).to have_content 'Quarto: Primeiro Quarto'
    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Comentário: Recomendo! Fui muito bem atendida!'
    expect(page).to have_content 'José Alves'
    expect(page).to have_content 'Nota: 3'
    expect(page).to have_content 'Comentário: Boa pousada. Preços não muito atrativos.'
    expect(page).to have_content 'Maria dos Santos'
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Ótima pousada!'
    expect(page).not_to have_content 'Resposta: Boa tarde, Lucas! Entramos em contato para entender melhor o que ocorreu. Aguardamos seu retorno.'
  end
    
  it 'e não existem avaliações' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    visit guesthouse_path(guesthouse)

    within '#recent-reviews' do
      expect(page).not_to have_link 'Todas Avaliações'
    end
  end
end