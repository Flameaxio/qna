require 'acceptance/acceptance_helper'

feature 'Create answer to question', '
  In order to give answer to a question
  As authenticated user
  I should be able to create an answer on the question page
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates an answer', js: true do
    authorize(user)

    visit question_path(question)
    fill_in 'answer[body]', with: 'My answer'
    click_on 'Submit'

    expect(current_path).to eq question_path(question)
    within 'div.answers', visible: false do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Authenticated user creates an answer with an attachment', js: true do
    authorize(user)

    visit question_path(question)
    within '.container .new_answer_wrapper' do
      fill_in 'answer[body]', with: 'My answer'
      click_on 'Add file'
      attach_file 'answer_attachments_attributes_0_file', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Submit'
    end

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
    end

  end

  scenario 'Unauthenticated user tries to create an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Your answer: '
    expect(page).to have_content 'Login in order to post answers!'
  end

  scenario 'Authenticated user tries to create answer with blank field', js: true do
    authorize(user)

    visit question_path(question)
    click_on 'Submit'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to_not have_content "Body"
    end
  end
end
