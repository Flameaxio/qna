require 'acceptance/acceptance_helper'

feature 'Edit question', '
  In order to fix mistakes
  As an author of the question
  I should be able to edit question
' do
  scenario 'Author tries to edit answer', js: true do
    user = create(:user)
    question = create(:question, user_id: user.id)

    authorize(user)
    visit question_path(question)
    within '.question' do
      click_on 'Edit'
      fill_in 'question[body]', with: 'New question'
      click_on 'Save'
      expect(page).to_not have_content question.body
      expect(page).to have_content('New question')
      expect(page).to_not have_selector('textarea')
    end
  end

  scenario 'Not author tries to edit answer' do
    question = create(:question)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link('Edit')
    end
  end
end
