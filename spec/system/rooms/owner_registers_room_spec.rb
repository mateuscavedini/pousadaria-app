require 'rails_helper'

describe 'Proprietário cadastra quarto' do
  it 'e deve estar autenticado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    visit root_path
    click_on 'Pousada Teste'

    expect(page).not_to have_link 'Adicionar Quarto'
  end

  it 'para pousada de qual não é dono' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)

    login_as maria
    visit new_guesthouse_room_path(jose_guesthouse)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso.'
  end

  it 'a partir da página inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Adicionar Quarto'

    expect(page).to have_content 'Cadastrar novo Quarto'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Área'
    expect(page).to have_field 'Capacidade Máxima'
    expect(page).to have_field 'Diária'
    expect(page).to have_unchecked_field 'Possui Banheiro?'
    expect(page).to have_unchecked_field 'Possui Varanda?'
    expect(page).to have_unchecked_field 'Possui Ar Condicionado?'
    expect(page).to have_unchecked_field 'Possui TV?'
    expect(page).to have_unchecked_field 'Possui Guarda-roupas?'
    expect(page).to have_unchecked_field 'Possui Cofre?'
    expect(page).to have_unchecked_field 'É acessível para PCDs?'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Adicionar Quarto'
    fill_in 'Nome', with: 'Primeiro Quarto'
    fill_in 'Descrição', with: 'Primeiro quarto a ser cadastrado'
    fill_in 'Área', with: '45'
    fill_in 'Capacidade Máxima', with: '2'
    fill_in 'Diária', with: '100,00'
    check 'Possui Banheiro?'
    check 'Possui Ar Condicionado?'
    check 'Possui TV?'
    check 'Possui Guarda-roupas?'
    check 'Possui Cofre?'
    check 'É acessível para PCDs?'
    click_on 'Enviar'

    expect(page).to have_content 'Quarto cadastrado com sucesso.'
    expect(page).to have_content 'Pousada Teste - Primeiro Quarto'
    expect(page).to have_content 'Nome: Primeiro Quarto'
    expect(page).to have_content 'Descrição: Primeiro quarto a ser cadastrado'
    expect(page).to have_content 'Área: 45m²'
    expect(page).to have_content 'Capacidade Máxima: 2 pessoa(s)'
    expect(page).to have_content 'Diária: R$ 100,00'
    expect(page).to have_content 'Possui Banheiro? Sim'
    expect(page).to have_content 'Possui Varanda? Não'
    expect(page).to have_content 'Possui Ar Condicionado? Sim'
    expect(page).to have_content 'Possui TV? Sim'
    expect(page).to have_content 'Possui Guarda-roupas? Sim'
    expect(page).to have_content 'Possui Cofre? Sim'
    expect(page).to have_content 'É acessível para PCDs? Sim'
  end

  it 'com dados incompletos' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Adicionar Quarto'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Área', with: ''
    fill_in 'Capacidade Máxima', with: ''
    fill_in 'Diária', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar o quarto.'
    expect(page).to have_content 'Erros:'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Área não pode ficar em branco'
    expect(page).to have_content 'Capacidade Máxima não pode ficar em branco'
    expect(page).to have_content 'Diária não pode ficar em branco'
  end
end