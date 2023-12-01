require 'rails_helper'

describe 'Proprietário altera status de um preço sazonal' do
  it 'para ativo' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    SeasonalRate.create!(start_date: 10.days.from_now, finish_date: 20.days.from_now, rate: 85.50, room: room, status: :inactive)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    within 'table' do
      click_on 'Ativar'
    end

    expect(page).to have_content 'O preço sazonal foi ativado com sucesso.'
    within 'table' do
      expect(page).to have_button 'Desativar'
      expect(page).not_to have_button 'Ativar'
    end
  end
  
  it 'para inativo' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    SeasonalRate.create!(start_date: 10.days.from_now, finish_date: 20.days.from_now, rate: 85.50, room: room, status: :active)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    within 'table' do
      click_on 'Desativar'
    end

    expect(page).to have_content 'O preço sazonal foi desativado com sucesso.'
    within 'table' do
      expect(page).to have_button 'Ativar'
      expect(page).not_to have_button 'Desativar'
    end
  end
end