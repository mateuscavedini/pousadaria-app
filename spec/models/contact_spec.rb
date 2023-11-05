require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '#valid?' do
    it 'inválido quando telefone vazio' do
      contact = Contact.new(phone: '', email: 'email@teste.com')

      contact.valid?

      expect(contact.errors.include? :phone).to be true
    end

    it 'inválido quando email vazio' do
      contact = Contact.new(email: '', phone: '11912344321')

      contact.valid?

      expect(contact.errors.include? :email).to be true
    end
  end
end
