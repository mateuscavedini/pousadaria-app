require 'rails_helper'

describe 'Hóspede realiza reserva de quarto' do
  it 'e deve estar autenticado' do
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

  it 'e vê resumo da reserva' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

    login_as guest, scope: :guest
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
    expect(page).to have_content "Data Inicial: #{I18n.localize(1.day.from_now.to_date)}"
    expect(page).to have_content 'Horário de Check-In: 11:00'
    expect(page).to have_content "Data Final: #{I18n.localize(5.days.from_now.to_date)}"
    expect(page).to have_content 'Horário de Check-Out: 10:30'
    expect(page).to have_content 'Quarto: Primeiro Quarto'
    expect(page).to have_content 'Formas de Pagamento: Dinheiro e Cartão de Crédito'
    expect(page).to have_button 'Confirmar Reserva'
  end

  it 'e confirma' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    guest = Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('COD12345')

    login_as guest, scope: :guest
    visit new_room_booking_path(room)
    fill_in 'Data Inicial', with: 1.day.from_now
    fill_in 'Data Final', with: 5.days.from_now
    fill_in 'Quantidade de Hóspedes', with: '1'
    click_on 'Enviar'
    click_on 'Confirmar Reserva'

    expect(page).to have_content 'Minhas Reservas'
    expect(page).to have_content 'Reserva confirmada com sucesso.'
    expect(page).to have_content 'COD12345'
    expect(page).to have_content 'Pousada Teste'
    expect(page).to have_content 'Primeiro Quarto'
    expect(page).to have_content I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content I18n.localize(5.days.from_now.to_date)
  end
end