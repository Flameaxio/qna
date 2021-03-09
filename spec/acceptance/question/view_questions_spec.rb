require 'rails_helper'

feature 'View questions', '
  In order to navigate between questions
  As any user
  I should be able to view all questions
' do
  given(:user) { create(:user) }
  scenario 'User sees all questions' do
    Question.create!(title: 'MyQuestion', body: 'MyBody', user_id: user.id)
    visit questions_path
    expect(page).to have_content('MyQuestion')
    expect(page).to have_content('MyBody')
  end
end
