require 'acceptance/acceptance_helper'

feature 'Select the best answer', '
  In order to highlight the best answer
  As an author of the question
  I should be able to select the best answer
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, user_id: user.id, question: question) }
  scenario 'Author tries to select the best answer', js: true do
    authorize(user)
    visit question_path(question)
    click_on 'Select as the best'
    wait_for_ajax
    expect(page).to have_css('div.green')
  end

  scenario 'Any user tries to select the best answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Select as the best'
  end
end
