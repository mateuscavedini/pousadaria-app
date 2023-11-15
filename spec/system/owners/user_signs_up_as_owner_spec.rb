require 'rails_helper'

describe 'Usuário cria conta como proprietário de pousada' do
  it 'a partir do menu' do
    visit root_path
    within '#owner-session-links' do
      click_on 'Registrar'
    end

    expect(current_path).to eq new_owner_registration_path
    expect(page).to have_content 'Registre-se como Proprietário'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
    expect(page).to have_button 'Criar Conta'
  end

  it 'com sucesso' do
    visit root_path
    within '#owner-session-links' do
      click_on 'Registrar'
    end
    fill_in 'Nome', with: 'Teste'
    fill_in 'E-mail', with: 'proprietario@teste.com'
    fill_in 'Senha', with: 'senha12345'
    fill_in 'Confirme sua senha', with: 'senha12345'
    click_on 'Criar Conta'

    expect(current_path).to eq new_guesthouse_path
    expect(page).to have_content 'Cadastre sua Pousada'
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within 'header nav' do
      expect(page).to have_content 'Teste | proprietario@teste.com'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_content 'Registre-se como:'
      expect(page).not_to have_link 'Hóspede'
      expect(page).not_to have_link 'Proprietário'
    end
  end

  it 'com dados insuficientes' do
    visit root_path
    within '#owner-session-links' do
      click_on 'Registrar'
    end
    fill_in 'Nome', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    click_on 'Criar Conta'

    expect(page).to have_content 'Não foi possível salvar proprietário'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end
end