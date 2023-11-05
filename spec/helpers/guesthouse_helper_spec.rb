require 'rails_helper'

describe GuesthouseHelper do
  describe '#guesthouse_allow_pets_string' do
    it 'retorna string personalizada quando pousada permite pets' do
      guesthouse = Guesthouse.new(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste 1', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', payment_methods: 'Dinheiro e Cartão de Crédito', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30')

      result = guesthouse_allow_pets_string(guesthouse)

      expect(result).to eq 'Esta pousada permite pets'
    end

    it 'retorna string personalizada quando pousada não permite pets' do
      guesthouse = Guesthouse.new(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste 1', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', payment_methods: 'Dinheiro e Cartão de Crédito', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30')

      result = guesthouse_allow_pets_string(guesthouse)

      expect(result).to eq 'Esta pousada não permite pets'
    end
  end

  describe '#guesthouse_format_time' do
    it 'retorna horário de check-in formatado' do
      guesthouse = Guesthouse.new(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste 1', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', payment_methods: 'Dinheiro e Cartão de Crédito', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30')

      result = guesthouse_format_time(guesthouse.check_in)

      expect(result).to eq '11:00'
    end

    it 'retorna horário de check-out formatado' do
      guesthouse = Guesthouse.new(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste 1', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', payment_methods: 'Dinheiro e Cartão de Crédito', allow_pets: true, usage_policy: 'Proibido fumar nos ambientes; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30')

      result = guesthouse_format_time(guesthouse.check_out)

      expect(result).to eq '10:30'
    end
  end
end