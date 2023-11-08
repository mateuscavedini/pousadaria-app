require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'com sucesso' do
    visit root_path

    within 'header' do
      expect(page).to have_content 'Pousadaria'
      expect(page).to have_link 'Pousadaria', href: root_path
    end
  end

  it 'e vê pousadas cadastradas que estão ativas' do
    first_owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    first_address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    first_contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
    second_owner = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    second_address_attributes = { street_name: 'Av do Teste', street_number: '200', complement: 'Bloco C', district: 'Jd. das Pousadas', city: 'São Paulo', state: 'SP', postal_code: '14010-191' }
    second_contact_attributes = { phone: '11998766789', email: 'contato@pousada.com' }
    third_owner = Owner.create!(name: 'André', email: 'andre@email.com', password: 'senha123')
    third_address_attributes = { street_name: 'Rua da Pousada', street_number: '23', district: 'Jd. dos Testes', city: 'Recife', state: 'PE', postal_code: '25610-132' }
    third_contact_attributes = { phone: '81958466489', email: 'suporte@pousada.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste 1', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: first_address_attributes, contact_attributes: first_contact_attributes, owner: first_owner, status: :active)
    Guesthouse.create!(corporate_name: 'Testes Brasil LTDA', trading_name: 'Pousada Teste 2', registration_number: '98765432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: second_address_attributes, contact_attributes: second_contact_attributes, owner: second_owner, status: :inactive)
    Guesthouse.create!(corporate_name: 'Pousadas e Hotéis Brasil LTDA', trading_name: 'Pousada Teste 3', registration_number: '14735432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: third_address_attributes, contact_attributes: third_contact_attributes, owner: third_owner, status: :active)

    visit root_path

    expect(page).to have_link 'Pousada Teste 1'
    expect(page).to have_content 'Endereço: Rua do Teste, 100, Jd. Testando, 11010-001, Jundiaí - SP'
    expect(page).to have_content 'Contato: pousada@teste.com | 11912344312'
    expect(page).to have_link 'Pousada Teste 3'
    expect(page).to have_content 'Endereço: Rua da Pousada, 23, Jd. dos Testes, 25610-132, Recife - PE'
    expect(page).to have_content 'Contato: suporte@pousada.com | 81958466489'
    expect(page).not_to have_link 'Pousada Teste 2'
    expect(page).not_to have_content 'Endereço: Av do Teste, 200, Bloco C, Jd. das Pousadas, 14010-191, São Paulo - SP'
    expect(page).not_to have_content 'Contato: contato@pousada.com | 11998766789'
  end

  it 'e não existem pousadas cadastradas' do
    visit root_path

    expect(page).to have_content 'Não existem pousadas cadastradas.'
  end
end