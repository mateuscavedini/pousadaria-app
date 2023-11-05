require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe '#valid?' do
    it 'inválido quando nome está vazio' do
      owner = Owner.new(name: '')

      owner.valid?

      expect(owner.errors.include? :name).to be true
    end
  end
end