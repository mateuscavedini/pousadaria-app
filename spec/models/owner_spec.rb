require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe '#valid?' do
    it 'false quando nome está em branco' do
      owner = Owner.new(email: 'teste@email.com', password: 'senha123')

      expect(owner).not_to be_valid
    end
  end

  describe '#description' do
    it 'imprime nome e email do proprietário' do
      owner = Owner.new(name: 'Teste', email: 'teste@email.com', password: 'senha123')
  
      expect(owner.description).to eq 'Teste | teste@email.com'
    end
  end
end
