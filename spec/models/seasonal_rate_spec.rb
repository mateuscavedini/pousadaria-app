require 'rails_helper'

RSpec.describe SeasonalRate, type: :model do
  describe '#valid?' do
    it 'inválido quando data inicial está vazia' do
      seasonal_rate = SeasonalRate.new(start_date: '')

      seasonal_rate.valid?

      expect(seasonal_rate.errors.include? :start_date).to be true
    end

    it 'inválido quando data final está vazia' do
      seasonal_rate = SeasonalRate.new(finish_date: '')

      seasonal_rate.valid?

      expect(seasonal_rate.errors.include? :finish_date).to be true
    end

    it 'inválido quando diária está vazia' do
      seasonal_rate = SeasonalRate.new(rate: '')

      seasonal_rate.valid?

      expect(seasonal_rate.errors.include? :rate).to be true
    end

    it 'inválido quando datas iniciais se sobrepõem' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

      first_seasonal_rate = SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 94.99, room: room)
      second_seasonal_rate = SeasonalRate.new(start_date: 1.day.from_now)

      second_seasonal_rate.valid?

      expect(second_seasonal_rate.errors.include? :base).to be true
    end

    it 'inválido quando datas finais se sobrepõem' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

      first_seasonal_rate = SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 94.99, room: room)
      second_seasonal_rate = SeasonalRate.new(finish_date: 5.days.from_now)

      second_seasonal_rate.valid?

      expect(second_seasonal_rate.errors.include? :base).to be true
    end

    it 'inválido quando datas intermediárias se sobrepõem' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      contact_attributes = { phone: '11912344321', email: 'pousada@teste.com' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, contact_attributes: contact_attributes, owner: owner)
      room = Room.create!(name: 'Primeiro Quarto', description: 'Primeiro quarto a ser cadastrado', area: 50, max_capacity: 2, daily_rate: 100, has_bathroom: true, has_balcony: false, has_air_conditioner: true, has_tv: true, has_wardrobe: true, has_safe: true, is_accessible: true, guesthouse: guesthouse)

      first_seasonal_rate = SeasonalRate.create!(start_date: 1.day.from_now, finish_date: 5.days.from_now, rate: 94.99, room: room)
      second_seasonal_rate = SeasonalRate.new(start_date: 2.days.from_now, finish_date: 6.days.from_now)

      second_seasonal_rate.valid?

      expect(second_seasonal_rate.errors.include? :base).to be true
    end

    it 'inválido quando data inicial é passada' do
      seasonal_rate = SeasonalRate.new(start_date: 1.day.ago)

      seasonal_rate.valid?

      expect(seasonal_rate.errors.include? :start_date).to be true
    end
    
    it 'inválido quando data final é passada' do
      seasonal_rate = SeasonalRate.new(finish_date: 1.day.ago)

      seasonal_rate.valid?

      expect(seasonal_rate.errors.include? :finish_date).to be true
    end

    it 'inválido quando data final é anterior a data inicial' do
      seasonal_rate = SeasonalRate.new(start_date: 5.days.from_now, finish_date: 1.day.from_now)

      seasonal_rate.valid?

      expect(seasonal_rate.errors.include? :finish_date).to be true
    end
  end
end
