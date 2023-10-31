require 'rails_helper'

describe 'Usuário visita página inicial' do
  it 'com sucesso' do
    visit root_path

    within 'header' do
      expect(page).to have_content 'Pousadaria'
      expect(page).to have_link 'Pousadaria', href: root_path
    end
  end
end