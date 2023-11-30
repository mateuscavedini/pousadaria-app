require 'rails_helper'

describe 'Exibe detalhes de uma pousada' do
  context 'GET /api/v1/guesthouses/:id' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      maria = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
      jose = Guest.create!(first_name: 'José', last_name: 'Alves', social_number: '99988877765', email: 'jose@email.com', password: 'senha123')
      ana = Guest.create!(first_name: 'Ana', last_name: 'Silva', social_number: '99911188827', email: 'ana@email.com', password: 'senha123')
      lucas = Guest.create!(first_name: 'Lucas', last_name: 'Ferreira', social_number: '11199922283', email: 'lucas@email.com', password: 'senha123')
      maria_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, total_price: room.calculate_total_price(1.day.from_now, 5.days.from_now), room: room, guest: maria, status: :finished)
      jose_booking = Booking.create!(start_date: 6.days.from_now, finish_date: 10.days.from_now, guests_number: 1, total_price: room.calculate_total_price(6.days.from_now, 10.days.from_now), room: room, guest: jose, status: :finished)
      ana_booking = Booking.create!(start_date: 11.days.from_now, finish_date: 15.days.from_now, guests_number: 1, total_price: room.calculate_total_price(11.days.from_now, 15.days.from_now), room: room, guest: ana, status: :finished)
      lucas_booking = Booking.create!(start_date: 16.days.from_now, finish_date: 20.days.from_now, guests_number: 1, total_price: room.calculate_total_price(16.days.from_now, 20.days.from_now), room: room, guest: lucas, status: :finished)
      Review.create!(rating: 4, comment: 'Recomendo! Fui muito bem atendida!', booking: ana_booking)
      Review.create!(rating: 1, comment: 'Não recomendo! Péssimo atendimento!', reply: 'Boa tarde, Lucas! Entramos em contato para entender melhor o que ocorreu. Aguardamos seu retorno.', booking: lucas_booking)
      Review.create!(rating: 3, comment: 'Boa pousada. Preços não muito atrativos.', booking: jose_booking)
      Review.create!(rating: 5, comment: 'Ótima pousada!', booking: maria_booking)

      get "/api/v1/guesthouses/#{guesthouse.id}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['trading_name']).to eq 'Pousada Teste'
      expect(json_response['description']).to eq 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.'
      expect(json_response['allow_pets']).to eq false
      expect(json_response['usage_policy']).to eq 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.'
      expect(json_response['check_in']).to eq '11:00'
      expect(json_response['check_out']).to eq '10:30'
      expect(json_response['payment_methods']).to eq 'Dinheiro e Cartão de Crédito'
      expect(json_response['average_rating']).to eq '3.25'
      expect(json_response['address']['street_name']).to eq 'Rua do Teste'
      expect(json_response['address']['street_number']).to eq '100'
      expect(json_response['address']['complement']).to be_empty
      expect(json_response['address']['district']).to eq 'Jd. Testando'
      expect(json_response['address']['city']).to eq 'Santos'
      expect(json_response['address']['state']).to eq 'SP'
      expect(json_response['address']['postal_code']).to eq '11010-001'
      expect(json_response['contact']['phone']).to eq '11912344321'
      expect(json_response['contact']['email']).to eq 'pousada@teste.com'
    end

    it 'mas não existem avaliações' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

      get "/api/v1/guesthouses/#{guesthouse.id}"
      json_response = JSON.parse(response.body)

      expect(json_response['average_rating']).to be_empty
    end

    it 'que está inativa' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner, status: :inactive)

      get "/api/v1/guesthouses/#{guesthouse.id}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['message']).to eq 'Pousada está inativa.'
    end

    it 'que não existe' do
      get '/api/v1/guesthouses/999999999'
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(json_response['message']).to eq 'Recurso não encontrado.'
    end

    it 'com erro interno' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Santos', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)

      allow(Guesthouse).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/guesthouses/#{guesthouse.id}"
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 500
      expect(json_response['message']).to eq 'Erro interno de servidor.'
    end
  end
end