require 'rails_helper'

describe 'Usuário cria conta como hóspede' do
  it 'a partir do menu' do
    visit root_path
    within '#guest-session-links' do
      click_on 'Registrar'
    end

    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
    expect(page).to have_button 'Criar Conta'
  end

  it 'com sucesso' do
    visit root_path
    within '#guest-session-links' do
      click_on 'Registrar'
    end
    fill_in 'Nome', with: 'Maria'
    fill_in 'Sobrenome', with: 'da Silva'
    fill_in 'CPF', with: '11122233345'
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'Senha', with: 'senha123'
    fill_in 'Confirme sua senha', with: 'senha123'
    click_on 'Criar Conta'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    within '#header-links' do
      expect(page).to have_content 'Maria da Silva'
      expect(page).to have_button 'Sair'
      expect(page).not_to have_content 'Hóspede'
      expect(page).not_to have_content 'Proprietário'
      expect(page).not_to have_link 'Registrar'
      expect(page).not_to have_link 'Entrar'
    end
  end

  it 'com dados insuficientes' do
    visit root_path
    within '#guest-session-links' do
      click_on 'Registrar'
    end
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    click_on 'Criar Conta'

    expect(page).to have_content 'Não foi possível salvar hóspede'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end

  it 'com cpf já cadastrado' do
    Guest.create!(first_name: 'Maria', last_name: 'da Silva', social_number: '11122233345', email: 'maria@email.com', password: 'senha123')

    visit root_path
    within '#guest-session-links' do
      click_on 'Registrar'
    end
    fill_in 'CPF', with: '11122233345'
    click_on 'Criar Conta'

    expect(page).to have_content 'Não foi possível salvar hóspede'
    expect(page).to have_content 'CPF já está em uso'
  end
end