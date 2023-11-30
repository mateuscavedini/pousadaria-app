require 'rails_helper'

describe 'Valida dados de reserva' do
  context 'GET /api/v1/rooms/:room_id/validate-booking' do
    it 'e são válidos' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      booking_params = { booking: { start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2 } }

      get "/api/v1/rooms/#{room.id}/validate-booking", params: booking_params
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['total_price']).to eq '500.0'
    end

    it 'e são insuficientes' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      booking_params = { booking: { start_date: '', finish_date: '', guests_number: '' } }

      get "/api/v1/rooms/#{room.id}/validate-booking", params: booking_params
      json_response = JSON.parse(response.body)

      expect(response.status).to be 400
      expect(json_response['message']).to eq 'Parâmetros inválidos.'
      expect(json_response['errors']).to include 'Data Inicial não pode ficar em branco'
      expect(json_response['errors']).to include 'Data Final não pode ficar em branco'
      expect(json_response['errors']).to include 'Quantidade de Hóspedes não pode ficar em branco'
    end

    it 'e são inválidos' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      booking_params = { booking: { start_date: 1.day.ago, finish_date: 5.days.ago, guests_number: 10 } }

      get "/api/v1/rooms/#{room.id}/validate-booking", params: booking_params
      json_response = JSON.parse(response.body)

      expect(response.status).to be 400
      expect(json_response['message']).to eq 'Parâmetros inválidos.'
      expect(json_response['errors']).to include 'Data Inicial deve ser futura'
      expect(json_response['errors']).to include 'Data Final deve ser futura'
      expect(json_response['errors']).to include 'Data Final deve ser posterior à Data Inicial'
      expect(json_response['errors']).to include 'Quantidade de Hóspedes deve respeitar a capacidade máxima do quarto'
    end

    it 'mas período está indisponível' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
      Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2, guest: guest, room: room, status: :pending)
      booking_params = { booking: { start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2 } }

      get "/api/v1/rooms/#{room.id}/validate-booking", params: booking_params
      json_response = JSON.parse(response.body)

      expect(response.status).to be 409
      expect(json_response['message']).to eq 'Parâmetros inválidos.'
      expect(json_response['errors']).to include 'Já existe uma reserva no período especificado'
    end

    it 'mas quarto está inativo' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :inactive)
      booking_params = { booking: { start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 2 } }

      get "/api/v1/rooms/#{room.id}/validate-booking", params: booking_params
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['message']).to eq 'Quarto está inativo.'
    end

    it 'mas quarto não existe' do
      get '/api/v1/rooms/9999999999/validate-booking'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['message']).to eq 'Recurso não encontrado.'
    end

    it 'com erro interno' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      allow(Room).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/rooms/#{room.id}/validate-booking"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 500
      expect(json_response['message']).to eq 'Erro interno de servidor.'
    end
  end
end