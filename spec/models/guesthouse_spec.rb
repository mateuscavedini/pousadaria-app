require 'rails_helper'

RSpec.describe Guesthouse, type: :model do
  describe '#valid?' do
    it 'inválido quando razão social está vazia' do
      guesthouse = Guesthouse.new(corporate_name: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :corporate_name).to be true
    end

    it 'inválido quando nome fantasia está vazio' do
      guesthouse = Guesthouse.new(trading_name: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :trading_name).to be true
    end

    it 'inválido quando cnpj está vazio' do
      guesthouse = Guesthouse.new(registration_number: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :registration_number).to be true
    end

    it 'inválido quando descrição está vazia' do
      guesthouse = Guesthouse.new(description: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :description).to be true
    end

    it 'inválido quando politicas de uso está vazia' do
      guesthouse = Guesthouse.new(usage_policy: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :usage_policy).to be true
    end

    it 'inválido quando check-in está vazio' do
      guesthouse = Guesthouse.new(check_in: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :check_in).to be true
    end

    it 'inválido quando check-out está vazio' do
      guesthouse = Guesthouse.new(check_out: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :check_out).to be true
    end

    it 'inválido quando formas de pagamento está vazia' do
      guesthouse = Guesthouse.new(payment_methods: '')

      guesthouse.valid?

      expect(guesthouse.errors.include? :payment_methods).to be true
    end

    it 'inválido quando CNPJ já está cadastrado' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', owner: owner)
      guesthouse = Guesthouse.new(registration_number: '12345678000100')

      guesthouse.valid?

      expect(guesthouse.errors.include? :registration_number).to be true
    end
  end
end
