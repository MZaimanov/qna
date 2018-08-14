require 'rails_helper'

feature 'User answers', %q{
  Для того чтобы обменяться знаниями
  Как зарегестрированный пользователь
  Пользователь может создавать ответы
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Аутетифицированный пользователь может создавать ответ' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    # within '.answers' do
      expect(page).to have_content 'My answer'
    # end
  end
end
