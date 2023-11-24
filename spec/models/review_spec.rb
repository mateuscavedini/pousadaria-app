require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '#valid?' do
    it 'inválido quando nota está vazia' do
      review = Review.new(rating: '')

      review.valid?

      expect(review.errors.include? :rating).to be true
    end

    it 'inválido quando comentário está vazio' do
      review = Review.new(comment: '')

      review.valid?

      expect(review.errors.include? :comment).to be true
    end
  end
end
