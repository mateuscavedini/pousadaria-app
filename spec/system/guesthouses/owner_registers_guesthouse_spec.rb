require 'rails_helper'

describe 'Proprietário cadastra sua pousada' do
  it 'e está autenticado' do
    visit root_path

    expect(page).not_to have_link 'Cadastrar Pousada'
  end

  it 'a partir do menu' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')

    login_as owner
    visit root_path
    within 'header nav' do
      click_on 'Cadastrar Pousada'
    end

    expect(page).to have_content 'Cadastre sua Pousada'
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Descrição'
    expect(page).to have_unchecked_field 'Permite Pets?'
    expect(page).to have_field 'Formas de Pagamento'
    expect(page).to have_field 'Horário de Check-In'
    expect(page).to have_field 'Horário de Check-Out'
    expect(page).to have_field 'Políticas de Uso'
    
    expect(page).to have_field 'CEP'
    expect(page).to have_field 'Nome da Rua'
    expect(page).to have_field 'Número'
    expect(page).to have_field 'Complemento'
    expect(page).to have_field 'Bairro'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'

    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'E-mail'

    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')

    login_as owner
    visit root_path
    click_on 'Cadastrar Pousada'
    fill_in 'Razão Social', with: 'Pousadas Brasil LTDA'
    fill_in 'Nome Fantasia', with: 'Pousada Teste'
    fill_in 'CNPJ', with: '12345678000100'
    fill_in 'Descrição', with: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.'
    check 'Permite Pets?'
    fill_in 'Formas de Pagamento', with: 'Dinheiro e Cartão de Crédito'
    fill_in 'Horário de Check-In', with: '11:00'
    fill_in 'Horário de Check-Out', with: '10:30'
    fill_in 'Políticas de Uso', with: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.'
    fill_in 'CEP', with: '11010-001'
    fill_in 'Nome da Rua', with: 'Rua do Teste'
    fill_in 'Número', with: '100'
    fill_in 'Complemento', with: ''
    fill_in 'Bairro', with: 'Jd. Testando'
    fill_in 'Cidade', with: 'Jundiaí'
    fill_in 'Estado', with: 'SP'
    fill_in 'Telefone', with: '11912344321'
    fill_in 'E-mail', with: 'pousada@teste.com'
    click_on 'Enviar'

    expect(page).to have_content 'Pousada cadastrada com sucesso.'
    expect(page).to have_content 'Pousada Teste'
    expect(page).to have_content 'Razão Social: Pousadas Brasil LTDA'
    expect(page).to have_content 'CNPJ: 12345678000100'
    expect(page).to have_content 'Descrição: Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.'
    expect(page).to have_content 'Métodos de Pagamento: Dinheiro e Cartão de Crédito'
    expect(page).to have_content 'Permite Pets? Sim'
    expect(page).to have_content 'Políticas de Uso: Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.'
    expect(page).to have_content 'Horário de Check-In: 11:00'
    expect(page).to have_content 'Horário de Check-Out: 10:30'
    expect(page).to have_content 'Endereço: Rua do Teste, 100, Jd. Testando, 11010-001, Jundiaí - SP'
    expect(page).to have_content 'Contato: pousada@teste.com | 11912344321'

    within 'header nav' do
      expect(page).to have_link 'Minha Pousada'
      expect(page).not_to have_link 'Cadastrar Pousada'
    end
  end

  it 'com dados insuficientes' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')

    login_as owner
    visit root_path
    click_on 'Cadastrar Pousada'
    fill_in 'Razão Social', with: ''
    fill_in 'Nome Fantasia', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Formas de Pagamento', with: ''
    fill_in 'Horário de Check-In', with: ''
    fill_in 'Horário de Check-Out', with: ''
    fill_in 'Políticas de Uso', with: ''
    fill_in 'CEP', with: ''
    fill_in 'Nome da Rua', with: ''
    fill_in 'Número', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'Telefone', with: ''
    fill_in 'E-mail', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar a pousada'
    expect(page).to have_content 'Erros:'
    expect(page).to have_content 'Nome da Rua não pode ficar em branco'
    expect(page).to have_content 'Número não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Horário de Check-In não pode ficar em branco'
    expect(page).to have_content 'Horário de Check-Out não pode ficar em branco'
    expect(page).to have_content 'Formas de Pagamento não pode ficar em branco'
  end

  it 'mas CNPJ já está em uso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    other_owner = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: other_owner)

    login_as owner
    visit root_path
    click_on 'Cadastrar Pousada'
    fill_in 'CNPJ', with: '12345678000100'
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar a pousada.'
    expect(page).to have_content 'CNPJ já está em uso'
  end

  it 'mas CEP já está em uso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    other_owner = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: other_owner)

    login_as owner
    visit root_path
    click_on 'Cadastrar Pousada'
    fill_in 'CEP', with: '11010-001'
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar a pousada.'
    expect(page).to have_content 'CEP já está em uso'
  end

  it 'mas já possui uma pousada cadastrada' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    login_as owner
    visit new_guesthouse_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você já possui uma pousada cadastrada.'
  end
end