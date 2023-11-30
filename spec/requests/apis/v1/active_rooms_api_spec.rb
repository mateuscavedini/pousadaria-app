require 'rails_helper'

describe 'Lista quartos ativos de pousada' do
  context 'GET /api/v1/guesthouses/:guesthouse_id/rooms' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner, status: :active)
      Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      Room.create!(name: 'Segundo Quarto', description: 'Segundo quarto a ser cadastrado', area: 75, max_capacity: 2, daily_rate: 175.50, has_bathroom: true, has_balcony: true, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :inactive)
      Room.create!(name: 'Terceiro Quarto', description: 'Terceiro quarto a ser cadastrado', area: 20, max_capacity: 2, daily_rate: 84.99, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: false, has_safe: false, is_accessible: false, guesthouse: guesthouse, status: :active)

      get "/api/v1/guesthouses/#{guesthouse.id}/rooms"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response.size).to eq 2
      expect(json_response[0]['name']).to eq 'Primeiro Quarto'
      expect(json_response[0]['description']).to eq 'Primeiro quarto a ser cadastrado'
      expect(json_response[0]['area']).to eq 50
      expect(json_response[0]['daily_rate']).to eq '100.0'
      expect(json_response[1]['name']).to eq 'Terceiro Quarto'
      expect(json_response[1]['description']).to eq 'Terceiro quarto a ser cadastrado'
      expect(json_response[1]['area']).to eq 20
      expect(json_response[1]['daily_rate']).to eq '84.99'
    end

    it 'mas não existem quartos a serem exibidos' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner, status: :active)

      get "/api/v1/guesthouses/#{guesthouse.id}/rooms"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response).to be_empty
    end

    it 'que não existe' do
      get '/api/v1/guesthouses/9999999999/rooms'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['message']).to eq 'Recurso não encontrado.'
    end

    it 'que está inativa' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner, status: :inactive)

      get "/api/v1/guesthouses/#{guesthouse.id}/rooms"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['message']).to eq 'Pousada está inativa.'
    end

    it 'com erro interno' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner, status: :active)
      allow(Room).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/guesthouses/#{guesthouse.id}/rooms"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 500
      expect(json_response['message']).to eq 'Erro interno de servidor.'
    end
  end
end