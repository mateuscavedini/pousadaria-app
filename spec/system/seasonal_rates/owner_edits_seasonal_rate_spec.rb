require 'rails_helper'

describe 'Proprietário edita preço sazonal' do
  it 'e deve estar autenticado' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    seasonal_rate = SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 75, room: room)

    visit edit_seasonal_rate_path(seasonal_rate)

    expect(current_path).to eq new_owner_session_path
  end

  it 'a partir da página inicial' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 75, room: room)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    within 'table' do
      click_on 'Editar'
    end

    expect(page).to have_content 'Editar Preço Sazonal'
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
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 75, room: room)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    within 'table' do
      click_on 'Editar'
    end
    fill_in 'Data Inicial', with: 10.days.from_now
    fill_in 'Data Final', with: 15.days.from_now
    fill_in 'Diária', with: 115
    click_on 'Enviar'

    expect(page).to have_content I18n.localize(10.days.from_now.to_date)
    expect(page).to have_content I18n.localize(15.days.from_now.to_date)
    expect(page).to have_content 'R$ 115,00'
  end

  it 'com dados incompletos/inválidos' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 75, room: room)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pousada Teste'
    click_on 'Primeiro Quarto'
    within 'table' do
      click_on 'Editar'
    end
    fill_in 'Data Inicial', with: 5.days.ago
    fill_in 'Data Final', with: 10.days.ago
    fill_in 'Diária', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível atualizar o preço sazonal.'
    expect(page).to have_content 'Erros:'
    expect(page).to have_content 'Data Inicial deve ser futura'
    expect(page).to have_content 'Data Final deve ser futura'
    expect(page).to have_content 'Data Final deve ser posterior à Data Inicial'
    expect(page).to have_content 'Diária não pode ficar em branco'
  end

  it 'de um quarto que não é de sua pousada' do
    maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
    jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
    address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
    contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
    guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: jose)
    room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
    jose_seasonal_rate = SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 75, room: room)

    login_as maria, scope: :owner
    visit edit_seasonal_rate_path(jose_seasonal_rate)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso.'
  end
end