require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid?' do
    it 'inválido quando nome da rua está vazio' do
      address = Address.new(street_name: '')

      address.valid?
      
      expect(address.errors.include? :street_name).to be true
    end

    it 'inválido quando número da rua está vazio' do
      address = Address.new(street_number: '')

      address.valid?
      
      expect(address.errors.include? :street_number).to be true
    end
    
    it 'inválido quando bairro está vazio' do
      address = Address.new(district: '')

      address.valid?
      
      expect(address.errors.include? :district).to be true
    end
    
    it 'inválido quando cidade está vazia' do
      address = Address.new(city: '')

      address.valid?
      
      expect(address.errors.include? :city).to be true
    end
    
    it 'inválido quando estado está vazio' do
      address = Address.new(state: '')

      address.valid?
      
      expect(address.errors.include? :state).to be true
    end
    
    it 'inválido quando cep está vazio' do
      address = Address.new(postal_code: '')

      address.valid?
      
      expect(address.errors.include? :postal_code).to be true
    end
    
    it 'válido quando complemento está vazio' do
      address = Address.new(complement: '')

      address.valid?
      
      expect(address.errors.include? :complement).to be false
    end

    it 'inválido quando CEP já está cadastrado' do
      owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')
      address_attributes = { street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', city: 'Jundiaí', state: 'SP', postal_code: '11010-001' }
      guesthouse = Guesthouse.create!(corporate_name: 'Pousadas Brasil LTDA', trading_name: 'Pousada Teste', registration_number: '12345678000100', description: 'Ambientes com Wi-Fi, suítes privadas, quartos compartilhados, segurança 24h.', allow_pets: false, usage_policy: 'Proibido fumar nos ambientes da pousada; Proibido barulho após as 22h.', check_in: '11:00', check_out: '10:30', payment_methods: 'Dinheiro e Cartão de Crédito', address_attributes: address_attributes, owner: owner)
      address = Address.new(postal_code: '11010-001')

      address.valid?

      expect(address.errors.include? :postal_code).to be true
    end
  end
end
