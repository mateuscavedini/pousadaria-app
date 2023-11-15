require 'rails_helper'

describe 'Proprietário se autentica' do
  it 'com sucesso' do
    Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')

    visit root_path
    within '#owner-session-links' do
      click_on 'Entrar'
    end
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'Senha', with: 'senha123'
    within 'main form' do
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    within 'header nav' do
      expect(page).to have_content 'Maria | maria@email.com'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_link 'Entrar'
    end
  end

  it 'e faz logout' do
    owner = Owner.create!(name: 'Maria', email: 'maria@email.com', password: 'senha123')

    login_as owner, scope: :owner
    visit root_path
    within 'header nav' do
      click_on 'Sair'
    end

    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_content 'Maria | maria@email.com'
    expect(page).not_to have_button 'Sair'
  end
end