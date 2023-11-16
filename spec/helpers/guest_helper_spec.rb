require 'rails_helper'

describe GuestHelper do
  describe '#guest_full_name' do
    it 'retorna o nome completo do hóspede' do
      guest = Guest.new(first_name: 'Maria', last_name: 'da Silva')

      result = guest_full_name(guest)

      expect(result).to eq 'Maria da Silva'
    end
  end
end