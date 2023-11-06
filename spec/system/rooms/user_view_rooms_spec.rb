require 'rails_helper'

describe 'Usuário vê quartos de pousada' do
  it 'a partir da página inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    Room.create!(name: 'Segundo Quarto', description: 'Segundo quarto a ser cadastrado', area: 75, max_capacity: 2, daily_rate: 175.50, has_bathroom: true, has_balcony: true, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'

    expect(page).to have_content 'Quartos Disponíveis:'
    expect(page).to have_content 'Nome:'
    expect(page).to have_link 'Primeiro Quarto'
    expect(page).to have_content 'Descrição: Primeiro quarto a ser cadastrado'
    expect(page).to have_content 'Área: 50m²'
    expect(page).to have_content 'Diária: R$ 100,00'
    expect(page).to have_link 'Segundo Quarto'
    expect(page).to have_content 'Descrição: Segundo quarto a ser cadastrado'
    expect(page).to have_content 'Área: 75m²'
    expect(page).to have_content 'Diária: R$ 175,50'
  end

  it 'apenas que estiverem ativos' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
    Room.create!(name: 'Segundo Quarto', description: 'Segundo quarto a ser cadastrado', area: 75, max_capacity: 2, daily_rate: 175.50, has_bathroom: true, has_balcony: true, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :inactive)
    Room.create!(name: 'Terceiro Quarto', description: 'Terceiro quarto a ser cadastrado', area: 20, max_capacity: 2, daily_rate: 10000, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: false, has_safe: false, is_accessible: false, guesthouse: guesthouse, status: :active)

    visit root_path
    click_on 'Pousada Teste'

    expect(page).to have_link 'Primeiro Quarto'
    expect(page).to have_link 'Terceiro Quarto'
    expect(page).not_to have_link 'Segundo Quarto'
  end

  it 'mas não há quartos a serem exibidos' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    visit root_path
    click_on 'Pousada Teste'

    expect(page).to have_content 'Não existem quartos a serem exibidos.'
  end
end