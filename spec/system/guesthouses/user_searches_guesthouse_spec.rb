require 'rails_helper'

describe 'Usuário pesquisa por pousada' do
  it 'a partir dos links de cidades' do
    first_owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    second_owner = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    third_owner = Owner.create!(name: 'André', email: 'andre@email.com', password: 'senha123')

    first_address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Salvador', state: 'BA', postal_code: '13010-321' }
    second_address_attributes = { street_name: 'Rua da Pousada', street_number: '23', district: 'Jd. dos Testes', city: 'Recife', state: 'PE', postal_code: '25610-132' }
    third_address_attributes = { street_name: 'Av da Pousada', street_number: '123', district: 'Pq. das Pousadas', city: 'Salvador', state: 'BA', postal_code: '45110-632' }

    first_contact_attributes = { phone: '71912344311', email: 'pousada@teste.com' }
    second_contact_attributes = { phone: '81958466489', email: 'suporte@pousada.com' }
    third_contact_attributes = { phone: '71957436439', email: 'suporte@teste.com' }

    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste 1', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: first_address_attributes, contact_attributes: first_contact_attributes, owner: first_owner, status: :active)
    Guesthouse.create!(corporate_name: 'Pousadas e Hotéis Brasil LTDA', trading_name: 'Pousada Teste 2', registration_number: '14735432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: second_address_attributes, contact_attributes: second_contact_attributes, owner: second_owner, status: :active)
    Guesthouse.create!(corporate_name: 'Pousada Salvador LTDA', trading_name: 'Pousada Teste 3', registration_number: '11755232000200', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: third_address_attributes, contact_attributes: third_contact_attributes, owner: third_owner, status: :active)

    visit root_path
    within '#city-links' do
      click_on 'Salvador'
    end

    expect(page).to have_content 'Resultados da Busca por: Salvador'
    expect(page).to have_content '2 pousadas encontradas'
    expect(page).to have_link 'Pousada Teste 1'
    expect(page).to have_link 'Pousada Teste 3'
    expect(page).not_to have_link 'Pousada Teste 2'
  end
end