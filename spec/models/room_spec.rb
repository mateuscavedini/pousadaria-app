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
end
