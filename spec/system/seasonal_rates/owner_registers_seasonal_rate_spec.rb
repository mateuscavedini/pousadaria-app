require 'rails_helper'

describe 'Proprietário registra novo preço sazonal' do
  it 'e deve estar autenticado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'

    expect(page).not_to have_link 'Adicionar Preço Sazonal'
  end

  it 'a partir da página inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Adicionar Preço Sazonal'

    expect(page).to have_field 'Data Inicial'
    expect(page).to have_field 'Data Final'
    expect(page).to have_field 'Diária'
    expect(page).to have_button 'Enviar'
  end

  it 'com sucesso' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Adicionar Preço Sazonal'
    fill_in 'Data Inicial', with: 10.days.from_now
    fill_in 'Data Final', with: 20.days.from_now
    fill_in 'Diária', with: 84.99
    click_on 'Enviar'

    expect(page).to have_content 'Preço Sazonal cadastrado com sucesso.'
    expect(page).to have_content "#{I18n.localize(10.days.from_now.to_date)} até #{I18n.localize(20.days.from_now.to_date)} - R$ 84,99"
  end
  
  it 'com dados insuficientes' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Adicionar Preço Sazonal'
    fill_in 'Data Inicial', with: ''
    fill_in 'Data Final', with: ''
    fill_in 'Diária', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar o preço sazonal.'
    expect(page).to have_content 'Erros:'
    expect(page).to have_content 'Data Inicial não pode ficar em branco'
    expect(page).to have_content 'Data Final não pode ficar em branco'
    expect(page).to have_content 'Diária não pode ficar em branco'
  end
  
  it 'para quarto que não é de sua pousada' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    jose_guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: jose_guesthouse)

    login_as maria
    visit new_room_seasonal_rate_path(jose_guesthouse)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso.'
  end

  it 'com sobreposição de datas' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 109.99, room: room)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Adicionar Preço Sazonal'
    fill_in 'Data Inicial', with: 1.day.from_now
    fill_in 'Data Final', with: 5.days.from_now
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar o preço sazonal.'
    expect(page).to have_content 'Não deve haver sobreposição de datas entre Preços Sazonais'
  end

  it 'com datas passadas' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Adicionar Preço Sazonal'
    fill_in 'Data Inicial', with: 5.days.ago
    fill_in 'Data Final', with: 1.day.ago
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar o preço sazonal.'
    expect(page).to have_content 'Data Inicial deve ser futura'
    expect(page).to have_content 'Data Final deve ser futura'
  end

  it 'com data final anterior à data inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

    login_as owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    click_on 'Adicionar Preço Sazonal'
    fill_in 'Data Inicial', with: 5.days.from_now
    fill_in 'Data Final', with: 1.day.from_now
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar o preço sazonal.'
    expect(page).to have_content 'Data Final deve ser posterior à Data Inicial'
  end
end