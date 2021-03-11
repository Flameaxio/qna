require 'acceptance/acceptance_helper'

feature 'Upvote or downvote the answer', '
  In order to my opinion of the answer
  As an authenticated user
  I want to be able to upvote or downvote the answer
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  scenario 'Authenticated user clicks on not active upvote button'
  scenario 'Authenticated user click on active upvote button'
  scenario 'Not authenticated user tries to upvote answer' do
    visit(question_path(question))
  end
end