require 'rails_helper'

describe OwnerHelper do
  describe '#owner_description' do
    it 'retorna a descrição do proprietário' do
      owner = Owner.new(name: 'Teste', email: 'teste@email.com', password: 'senha123')

      result = owner_description(owner)

      expect(result).to eq 'Teste | teste@email.com'
    end
  end
end