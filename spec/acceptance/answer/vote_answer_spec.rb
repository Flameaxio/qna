require 'acceptance/acceptance_helper'

feature 'Vote for answer', '
  In order to convey my opinion
  as an authenticated user and not an author
  I want to be able to vote for answer
' do
  given(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, user_id: author.id, question: question) }

  scenario 'User votes for answer', js: true do
    sign_in user

    visit question_path(question)

    first(".vote-button").click
    expect(page).to have_content('1')
    all(".vote-button").last.click
    expect(page).to have_content('-1')
    all(".vote-button").last.click
    expect(page).to have_content('0')
  end
  scenario 'Author votes for answer', js: true do
    sign_in author

    visit question_path(question)

    accept_alert("You can't vote for your answer!") do
      first(".vote-button").click
    end
  end
end
