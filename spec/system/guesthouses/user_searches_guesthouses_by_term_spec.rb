require 'rails_helper'

describe 'Usuário busca pousadas por termo' do
  it 'a partir do menu' do
    visit root_path

    within 'header form' do
      expect(page).to have_field 'Buscar Pousadas'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'e encontra uma pousada' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada do Litoral', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner, status: :active)

    visit root_path
    fill_in 'Buscar Pousadas', with: 'litoral'
    click_on 'Buscar'

    expect(page).to have_content 'Resultados da Busca por: litoral'
    expect(page).to have_content '1 pousada encontrada'
    expect(page).to have_link 'Pousada do Litoral'
  end

  it 'e encontra múltiplas pousadas' do
    first_owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    second_owner = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    third_owner = Owner.create!(name: 'André', email: 'andre@email.com', password: 'senha123')
    fourth_owner = Owner.create!(name: 'Paula', email: 'paula@email.com', password: 'senha123')

    first_address_attributes = { street_name: 'Rua dos Testes', street_number: '100', district: 'Jd. Testando', city: 'Salvador', state: 'BA', postal_code: '13010-321' }
    second_address_attributes = { street_name: 'Rua da Pousada', street_number: '23', district: 'Jd. dos Testes', city: 'Recife', state: 'PE', postal_code: '25610-132' }
    third_address_attributes = { street_name: 'Av da Pousada', street_number: '123', district: 'Pq. dos Testes', city: 'Recife', state: 'PE', postal_code: '25110-712' }
    fourth_address_attributes = { street_name: 'Av da Pousada', street_number: '123', district: 'Pq. dos Recifes', city: 'Salvador', state: 'BA', postal_code: '45110-632' }

    first_contact_attributes = { phone: '71912344311', email: 'pousada@teste.com' }
    second_contact_attributes = { phone: '81958466489', email: 'suporte@pousada.com' }
    third_contact_attributes = { phone: '81957436439', email: 'suporte@teste.com' }
    fourth_contact_attributes = { phone: '71914437419', email: 'contato@pousada.com' }

    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada dos Recifes', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: first_address_attributes, contact_attributes: first_contact_attributes, owner: first_owner, status: :active)
    Guesthouse.create!(corporate_name: 'Pousadas e Hotéis Brasil LTDA', trading_name: 'Pousada A', registration_number: '14735432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: second_address_attributes, contact_attributes: second_contact_attributes, owner: second_owner, status: :inactive)
    Guesthouse.create!(corporate_name: 'Pousada Recife LTDA', trading_name: 'Pousada B', registration_number: '11715212000200', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: third_address_attributes, contact_attributes: third_contact_attributes, owner: third_owner, status: :active)
    Guesthouse.create!(corporate_name: 'Pousada Salvador LTDA', trading_name: 'Pousada das Palmeiras', registration_number: '11755232000200', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: fourth_address_attributes, contact_attributes: fourth_contact_attributes, owner: fourth_owner, status: :active)

    visit root_path
    fill_in 'Buscar Pousadas', with: 'recife'
    click_on 'Buscar'

    expect(page).to have_content 'Resultados da Busca por: recife'
    expect(page).to have_content '3 pousadas encontradas'
    expect(page).to have_link 'Pousada dos Recifes'
    expect(page).to have_link 'Pousada B'
    expect(page).to have_link 'Pousada das Palmeiras'
    expect(page).not_to have_link 'Pousada A'
  end

  it 'e não encontra nenhuma pousada' do
    visit root_path
    fill_in 'Buscar Pousadas', with: 'recife'
    click_on 'Buscar'

    expect(page).to have_content 'Resultados da Busca por: recife'
    expect(page).to have_content '0 pousadas encontradas'
  end
end