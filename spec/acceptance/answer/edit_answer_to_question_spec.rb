require 'acceptance/acceptance_helper'

feature 'Edit answer to question', '
  In order to fix mistakes
  As an author of the answer
  I should be able to edit answer
' do

  scenario 'Author tries to edit answer', js: true do
    user = create(:user)
    question = create(:question, user_id: user.id)
    answer = create(:answer, question: question, user_id: user.id)

    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'Edit'
      fill_in 'answer[body]', with: 'New answer'
      click_on 'Save'
      expect(page).to_not have_content answer.body
      expect(page).to have_content('New answer')
      expect(page).to_not have_selector('textarea')
    end
  end

  scenario 'Not author tries to edit answer' do
    question = create(:question)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link('Edit')
    end
  end
end