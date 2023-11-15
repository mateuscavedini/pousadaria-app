require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe '#valid?' do
    it 'inválido quando nome está vazio' do
      guest = Guest.new(first_name: '')

      guest.valid?

      expect(guest.errors.include? :first_name).to be true
    end

    it 'inválido quando sobrenome está vazio' do
      guest = Guest.new(last_name: '')

      guest.valid?

      expect(guest.errors.include? :last_name).to be true
    end

    it 'inválido quando cpf está vazio' do
      guest = Guest.new(social_number: '')

      guest.valid?

      expect(guest.errors.include? :social_number).to be true
    end

    it 'inválido quando cpf já está em uso' do
      Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

      other_guest = Guest.new(social_number: '11122233345')

      other_guest.valid?

      expect(other_guest.errors.include? :social_number).to be true
    end
  end
end
