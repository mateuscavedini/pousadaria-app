require 'rails_helper'

describe AddressHelper do
  describe '#address_description' do
    it 'retorna a descrição do endereço sem complemento' do
      address = Address.new(street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', postal_code: '13060-190', city: 'Piracicaba', state: 'SP', complement: '')

      result = address_description(address)

      expect(result).to eq 'Rua do Teste, 100, Jd. Testando, 13060-190, Piracicaba - SP'
    end

    it 'retorna a descrição do endereço com complemento' do
      address = Address.new(street_name: 'Rua do Teste', street_number: '100', district: 'Jd. Testando', postal_code: '13060-190', city: 'Piracicaba', state: 'SP', complement: 'Bloco C')

      result = address_description(address)

      expect(result).to eq 'Rua do Teste, 100, Bloco C, Jd. Testando, 13060-190, Piracicaba - SP'
    end
  end
end