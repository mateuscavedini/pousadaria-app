require 'rails_helper'

RSpec.describe Room, type: :model do
  describe '#valid?' do
    it 'inválido quando nome está vazio' do
      room = Room.new(name: '')

      room.valid?

      expect(room.errors.include? :name).to be true
    end

    it 'inválido quando descrição está vazia' do
      room = Room.new(description: '')

      room.valid?

      expect(room.errors.include? :description).to be true
    end

    it 'inválido quando área está vazia' do
      room = Room.new(area: '')

      room.valid?

      expect(room.errors.include? :area).to be true
    end

    it 'inválido quando capacidade máxima está vazia' do
      room = Room.new(max_capacity: '')

      room.valid?

      expect(room.errors.include? :max_capacity).to be true
    end

    it 'inválido quando diária está vazia' do
      room = Room.new(daily_rate: '')

      room.valid?

      expect(room.errors.include? :daily_rate).to be true
    end
  end

  describe '#calculate_total_price' do
    it 'em período sem preços sazonais' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

      result = room.calculate_total_price(1.day.from_now, 5.days.from_now)

      expect(result).to eq 500
    end

    it 'em período com um preço sazonal' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
      SeasonalRate.create!(start_date: 4.days.from_now, finish_date: 5.days.from_now, rate: 85.50, room: room)

      result = room.calculate_total_price(1.day.from_now, 5.days.from_now)

      expect(result).to eq (3 * 100) + (2 * 85.50)
    end

    it 'em período com múltiplos preços sazonais' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
      SeasonalRate.create!(start_date: 2.days.from_now, finish_date: 3.days.from_now, rate: 85.50, room: room)
      SeasonalRate.create!(start_date: 4.days.from_now, finish_date: 5.days.from_now, rate: 115.50, room: room)

      result = room.calculate_total_price(1.day.from_now, 5.days.from_now)

      expect(result).to eq 100 + (2 * 85.50) + (2 * 115.50)
    end

    it 'em período sem dias regulares' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
      SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 85.50, room: room)

      result = room.calculate_total_price(1.day.from_now, 5.days.from_now)

      expect(result).to eq 5 * 85.50
    end
  end

  describe '#calculate_proportional_total_price' do
    it 'com 1 minuto de atraso' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '10:30', check_out: '11:00', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
      check_in = 4.days.ago
      check_out = Time.zone.now.at_beginning_of_day + 11.hours + 1.minute

      result = room.calculate_proportional_total_price(check_in, check_out)

      expect(result).to eq 600
    end

    it 'com 1 minuto de antecedência' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '10:30', check_out: '11:00', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)
      check_in = 4.days.ago
      check_out = Time.zone.now.at_beginning_of_day + 10.hours + 59.minutes

      result = room.calculate_proportional_total_price(check_in, check_out)

      expect(result).to eq 500
    end
  end
end
