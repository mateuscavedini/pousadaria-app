require 'rails_helper'

describe 'Lista pousadas ativas' do
  context 'GET /api/v1/guesthouses' do
    it 'com sucesso' do
      maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
      andre = Owner.create!(name: 'André', email: 'andre@email.com', password: 'senha123')
      maria_address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      jose_address_attributes = { street_name: 'Av do Teste', street_number: '200', district: 'Jd. das Pousadas', city: 'São Paulo', state: 'SP', postal_code: '14010-191' }
      andre_address_attributes = { street_name: 'Rua da Pousada', street_number: '23', district: 'Jd. dos Testes', city: 'Recife', state: 'PE', postal_code: '25610-132' }
      maria_contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
      jose_contact_attributes = { phone: '11998766789', email: 'contato@pousada.com' }
      andre_contact_attributes = { phone: '81958466489', email: 'suporte@pousada.com' }

      Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste 1', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: maria_address_attributes, contact_attributes: maria_contact_attributes, owner: maria, status: :active)
      Guesthouse.create!(corporate_name: 'Testes Brasil LTDA', trading_name: 'Pousada Teste 2', registration_number: '98765432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: jose_address_attributes, contact_attributes: jose_contact_attributes, owner: jose, status: :inactive)
      Guesthouse.create!(corporate_name: 'Pousadas e Hotéis Brasil LTDA', trading_name: 'Pousada Teste 3', registration_number: '14735432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: andre_address_attributes, contact_attributes: andre_contact_attributes, owner: andre, status: :active)

      get '/api/v1/guesthouses'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response.size).to eq 2
      expect(json_response[0]['trading_name']).to eq 'Pousada Teste 1'
      expect(json_response[0]['address']['city']).to eq 'Santos'
      expect(json_response[1]['trading_name']).to eq 'Pousada Teste 3'
      expect(json_response[1]['address']['city']).to eq 'Recife'
    end

    it 'mas não existem pousadas a serem exibidas' do
      get '/api/v1/guesthouses'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response).to be_empty
    end

    it 'com termo de busca' do
      maria = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      jose = Owner.create!(name: 'José', email: 'jose@email.com', password: 'senha123')
      andre = Owner.create!(name: 'André', email: 'andre@email.com', password: 'senha123')
      maria_address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      jose_address_attributes = { street_name: 'Av do Teste', street_number: '200', district: 'Jd. das Pousadas', city: 'São Paulo', state: 'SP', postal_code: '14010-191' }
      andre_address_attributes = { street_name: 'Rua da Pousada', street_number: '23', district: 'Jd. dos Testes', city: 'Recife', state: 'PE', postal_code: '25610-132' }
      maria_contact_attributes = { phone: '11912344312', email: 'pousada@teste.com' }
      jose_contact_attributes = { phone: '11998766789', email: 'contato@pousada.com' }
      andre_contact_attributes = { phone: '81958466489', email: 'suporte@pousada.com' }

      Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: maria_address_attributes, contact_attributes: maria_contact_attributes, owner: maria, status: :active)
      Guesthouse.create!(corporate_name: 'Testes Brasil LTDA', trading_name: 'Pousada Litoral Sul', registration_number: '98765432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: jose_address_attributes, contact_attributes: jose_contact_attributes, owner: jose, status: :inactive)
      Guesthouse.create!(corporate_name: 'Pousadas e Hotéis Brasil LTDA', trading_name: 'Pousada Litoral Norte', registration_number: '14735432000900', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '12:00', check_out: '11:00', payment_methods: 'Dinheiro, Cartão de Crédito e Pix', address_attributes: andre_address_attributes, contact_attributes: andre_contact_attributes, owner: andre, status: :active)

      get '/api/v1/guesthouses', params: { query: 'litoral' }
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response.size).to eq 1
      expect(json_response[0]['trading_name']).to eq 'Pousada Litoral Norte'
    end

    it 'com erro interno' do
      allow(Guesthouse).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/guesthouses'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 500
      expect(json_response['message']).to eq 'Erro interno de servidor.'
    end
  end
end