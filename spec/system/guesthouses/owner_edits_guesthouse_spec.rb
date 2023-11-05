require 'rails_helper'

describe 'Proprietário edita sua pousada' do
  it 'e deve estar autenticado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    visit edit_guesthouse_path(guesthouse)

    expect(current_path).to eq new_owner_session_path
  end

  it 'com sucesso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    login_as owner
    visit root_path
    within 'header nav' do
      click_on 'Minha Pousada'
    end
    click_on 'Editar'
    fill_in 'Nome da Rua', with: 'Av do Novo Teste'
    fill_in 'Complemento', with: 'Bloco B'
    fill_in 'E-mail', with: 'contato@pousada.com'
    fill_in 'Descrição', with: 'Nova descrição'
    check 'Permite Pets'
    click_on 'Enviar'

    expect(page).to have_content 'Endereço: Av do Novo Teste, 100, Bloco B, Jd. Testando, 11010-001, Jundiaí - SP'
    expect(page).to have_content 'Contato: contato@pousada.com | 11912344321'
    expect(page).to have_content 'Descrição: Nova descrição'
    expect(page).to have_content 'Permite Pets: Esta pousada permite pets'
  end

  it 'com dados insuficientes' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

    login_as owner
    visit root_path
    click_on 'Minha Pousada'
    click_on 'Editar'
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

    expect(page).to have_content 'Erros:'
    expect(page).to have_content 'Não foi possível atualizar a pousada'
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

  it 'e não consegue editar pousadas que não sejam suas' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada da Maria', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: maria)
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    other_address_attributes = { street_name: 'Rua do José', street_number: '10', district: 'Jd. das Palmeiras', city: 'São Paulo', state: 'SP', postal_code: '21040-051' }
    other_contact_attributes = { phone: '11952387221', email: 'contato@palmeiras.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas e Hotéis Brasil LTDA', trading_name: 'Pousada do José', registration_number: '98765432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: other_address_attributes, contact_attributes: other_contact_attributes, owner: jose)

    login_as maria
    visit edit_guesthouse_path(jose_guesthouse)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa pousada.'
  end
end