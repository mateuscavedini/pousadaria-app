require 'rails_helper'

describe ContactHelper do
  describe '#contact_description' do
    it 'retorna a descrição do contato' do
      contact = Contact.new(phone: '11998766789', email: 'contato@pousada.com')

      result = contact_description(contact)

      expect(result).to eq 'contato@pousada.com | 11998766789'
    end
  end
end