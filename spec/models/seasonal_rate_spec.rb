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

    pending 'overlap'
    pending 'datas passada'
    pending 'data final antes de data inicial'
  end
end
