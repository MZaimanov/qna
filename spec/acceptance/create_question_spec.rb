require 'rails_helper'

feature 'Create question', %q{
  Для того чтобы получить ответ от сообщества
  Как аутетифицированный пользователь
  Я хочу иметь возможность задовать вопросы.
} do

  given(:user) { create(:user) }

  scenario 'Аутетифицированный пользователь создает вопрос' do
    User.create!(email: 'user@test.ru', password: '12345678')

    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Ваш вопрос успешно создан'
  end

  scenario 'НЕ-Аутетифицированный пользователь создает вопрос' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end


end
