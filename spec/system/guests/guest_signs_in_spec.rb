require 'rails_helper'

describe 'Hóspede se autentica' do
  it 'com sucesso' do
    Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

    visit root_path
    within '#guest-session-links' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'Senha', with: 'senha123'
    within 'main form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso.'
    within 'header nav' do
      expect(page).to have_content 'Maria da Silva'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_link 'Registrar'
      expect(page).not_to have_link 'Entrar'
    end
  end

  it 'e faz logout' do
    guest = Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

    login_as guest, scope: :guest
    visit root_path
    within 'header nav' do
      click_on 'Sair'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Logout efetuado com sucesso.'
    within 'header nav' do
      expect(page).to have_link 'Registrar'
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_content 'Maria da Silva'
      expect(page).not_to have_button 'Sair'
    end
  end
end