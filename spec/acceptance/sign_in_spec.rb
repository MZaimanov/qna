require_relative 'acceptance_helper'

feature 'Вход пользователя в систему', %q{
  Для того чтобы задавать вопросы
  Как пользователь
  Нужна возможность входа в систему
} do

  given(:user) { create(:user) }

  scenario 'Зарегестрированный пользователь может войти' do

    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Не зарегестрированный пользователь не может войти' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
