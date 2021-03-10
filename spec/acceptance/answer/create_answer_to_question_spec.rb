require 'acceptance/acceptance_helper'

feature 'Create answer to question', '
  In order to give answer to a question
  As authenticated user
  I should be able to create an answer on the question page
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates an answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer[body]', with: 'My answer'
    click_on 'Submit'

    expect(current_path).to eq question_path(question)
    within 'div.answers', visible: false do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Unauthenticated user tries to create an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Your answer: '
    expect(page).to have_content 'Login in order to post answers!'
  end
end