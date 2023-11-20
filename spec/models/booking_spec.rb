require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe '#valid?' do
    it 'inválido quando data inicial está vazia' do
      booking = Booking.new(start_date: '')

      booking.valid?

      expect(booking.errors.include? :start_date).to be true
    end

    it 'inválido quando data final está vazia' do
      booking = Booking.new(finish_date: '')

      booking.valid?

      expect(booking.errors.include? :finish_date).to be true
    end

    it 'inválido quando número de hóspedes está vazio' do
      booking = Booking.new(guests_number: '')

      booking.valid?

      expect(booking.errors.include? :guests_number).to be true
    end

    it 'inválido quando data inicial é passada' do
      booking = Booking.new(start_date: 1.day.ago)

      booking.valid?

      expect(booking.errors.include? :start_date).to be true
    end

    it 'inválido quando data final é passada' do
      booking = Booking.new(finish_date: 1.day.ago)

      booking.valid?

      expect(booking.errors.include? :finish_date).to be true
    end
    
    it 'inválido quando data final é anterior à data inicial' do
      booking = Booking.new(start_date: 5.days.from_now, finish_date: 1.day.from_now)

      booking.valid?

      expect(booking.errors.include? :finish_date).to be true
    end

    it 'deve ter um código' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse, status: :active)
      guest = Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

      booking = Booking.create(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, total_price: 500, room: room, guest: guest)

      expect(booking).to be_valid
    end

    it 'inválido quando já existe uma reserva pendente no período especificado' do
      maria = Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

      Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, room: room, guest: maria, status: :pending)
      booking = Booking.new(start_date: 2.days.from_now, finish_date: 6.days.from_now, room: room)

      booking.valid?

      expect(booking.errors.include? :base).to be true
    end
    
    it 'inválido quando já existe uma reserva em andamento no período especificado' do
      maria = Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

      Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, room: room, guest: maria, status: :ongoing)
      booking = Booking.new(start_date: 2.days.from_now, finish_date: 6.days.from_now, room: room)

      booking.valid?

      expect(booking.errors.include? :base).to be true
    end

    it 'inválido quando número de hóspedes é superior à capacidade máxima do quarto' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

      booking = Booking.new(guests_number: 5, room: room)

      booking.valid?

      expect(booking.errors.include? :guests_number).to be true
    end
  end

  describe 'Gera um código aleatório' do
    it 'ao criar uma nova reserva' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
      guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

      booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, total_price: 500, room: room, guest: guest)

      expect(booking.code).not_to be_empty
      expect(booking.code.length).to eq 8
    end

    it 'e é único' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
      guest = Guest.create!(first_name: 'Maria', last_name: 'dos Santos', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

      first_booking = Booking.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, guests_number: 1, total_price: 500, room: room, guest: guest)
      second_booking = Booking.create!(start_date: 10.days.from_now, finish_date: 15.days.from_now, guests_number: 1, total_price: 500, room: room, guest: guest)

      expect(second_booking.code).not_to eq first_booking.code
    end
  end
end
